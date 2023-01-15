rec {
  description = "Lotte's NixOS installation";

  # Use NixOS unstable
  inputs = {
    # Sorted by name
    attic = {
      #url = "github:zhaofengli/attic";
      url = "github:DarkKirb/attic/env-config";
      inputs.crane.follows = "crane";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    cargo2nix = {
      url = "github:cargo2nix/cargo2nix";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
    };
    chir-rs = {
      url = "github:DarkKirb/chir.rs";
      inputs.cargo2nix.follows = "cargo2nix";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    crane = {
      url = "github:ipetkov/crane";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dns = {
      url = "github:DarkKirb/dns.nix";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ema.url = "github:EmaApps/ema";
    emanote = {
      url = "github:EmaApps/emanote";
      inputs.ema.follows = "ema";
      inputs.flake-parts.follows = "flake-parts";
      inputs.haskell-flake.follows = "haskell-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    haskell-flake.url = "github:srid/haskell-flake";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hosts-list = {
      url = "github:StevenBlack/hosts";
      flake = false;
    };
    hydra = {
      url = "github:NixOS/hydra";
      #inputs.nix.follows = "nix";
      #inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-packages = {
      url = "github:DarkKirb/nix-packages";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nixpkgs.url = "github:NixOS/nixpkgs";
    nixpkgs-noto-variable.url = "github:NixOS/nixpkgs/1988f9a17fc1c2ab11f5817adf34a4eb8d06454d";
    nur.url = "github:nix-community/NUR";
    prismmc = {
      url = "github:PrismLauncher/PrismLauncher";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };
    tomlplusplus = {
      url = "github:marzer/tomlplusplus";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    sops-nix,
    home-manager,
    nur,
    ...
  } @ args: let
    systems = [
      {
        name = "nixos-8gb-fsn1-1"; # Hetzner Server
        system = "x86_64-linux";
      }
      {
        name = "nutty-noon"; # PC
        system = "x86_64-linux";
      }
      {
        name = "thinkrac"; # Thinkpad T470
        system = "x86_64-linux";
      }
      {
        name = "nas"; # My nas
        system = "x86_64-linux";
      }
      {
        name = "instance-20221213-1915"; # Oracle server
        system = "aarch64-linux";
      }
      {
        name = "server-x86_64"; # archetype
        system = "x86_64-linux";
        configName = "archetype-server";
      }
      {
        name = "server-aarch64"; # archetype
        system = "aarch64-linux";
        configName = "archetype-server";
      }
      {
        name = "desktop-x86_64"; # archetype
        system = "x86_64-linux";
        configName = "archetype-desktop";
      }
    ];
  in rec {
    nixosConfigurations = builtins.listToAttrs (map
      ({
        name,
        system,
        configName ? name,
      }: {
        inherit name;
        value =
          nixpkgs.lib.nixosSystem
          {
            inherit system;
            specialArgs =
              args
              // {
                inherit system;
              };
            modules = [
              (./config + "/${configName}.nix")
              ./config/default.nix
              sops-nix.nixosModules.sops
              home-manager.nixosModules.home-manager
              ({pkgs, ...}: {
                nixpkgs.overlays = [
                  nur.overlay
                  args.prismmc.overlay
                ];
                home-manager.extraSpecialArgs = args // {inherit system;};
              })
              (import utils/link-input.nix args)
            ];
          };
      })
      systems);
    overlays = {
      x86_64-linux = import ./overlays args "x86_64-linux";
      aarch64-linux = import ./overlays args "aarch64-linux";
    };
    devShell.x86_64-linux = let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [self.overlays.x86_64-linux];
      };
    in
      pkgs.mkShell {
        nativeBuildInputs = with pkgs; [
          sops
          ssh-to-age
          nix-prefetch
          nix-prefetch-git
          jq
          bundix
          python3
          python3Packages.yapf
          github-cli
          statix
          backblaze-b2
        ];
      };
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
    homeConfigurations = builtins.listToAttrs (nixpkgs.lib.foldr (a: b: a ++ b) [] (map (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          self.overlays.${system}
          nur.overlay
          args.prismmc.overlay
        ];
        config.allowUnfree = true;
      };
    in [
      {
        name = "base-${system}";
        value = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            (import ./config/home-manager/base.nix false)
            {
              home.username = "base";
              home.homeDirectory = "/home/base";
            }
          ];
          extraSpecialArgs = args // {inherit system;};
        };
      }
      {
        name = "base-desktop-${system}";
        value = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            (import ./config/home-manager/base.nix true)
            {
              home.username = "base";
              home.homeDirectory = "/home/base";
            }
          ];
          extraSpecialArgs = args // {inherit system;};
        };
      }
      {
        name = "root-${system}";
        value = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./config/home-manager/root.nix
            {
              home.username = "root";
              home.homeDirectory = "/root";
            }
          ];
          extraSpecialArgs = args // {inherit system;};
        };
      }
      {
        name = "darkkirb-${system}";
        value = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            (import ./config/home-manager/darkkirb.nix {
              desktop = false;
              args = {};
            })
            {
              home.username = "darkkirb";
              home.homeDirectory = "/home/darkkirb";
            }
          ];
          extraSpecialArgs = args // {inherit system;};
        };
      }
      {
        name = "darkkirb-desktop-${system}";
        value = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            (import ./config/home-manager/darkkirb.nix {
              desktop = true;
              args = {};
            })
            {
              home.username = "darkkirb";
              home.homeDirectory = "/home/darkkirb";
            }
          ];
          extraSpecialArgs = args // {inherit system;};
        };
      }
      {
        name = "miifox-${system}";
        value = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./config/home-manager/miifox.nix
            {
              home.username = "miifox";
              home.homeDirectory = "/home/miifox";
            }
          ];
          extraSpecialArgs = args // {inherit system;};
        };
      }
    ]) ["x86_64-linux" "aarch64-linux"]));
    hydraJobs =
      (builtins.listToAttrs (map
        ({
          name,
          system,
          ...
        }: {
          inherit name;
          value = {
            ${system} = nixosConfigurations.${name}.config.system.build.toplevel;
          };
        })
        systems))
      // {
        inherit devShell;
        homeConfigurations = nixpkgs.lib.mapAttrs (_: v: v.activationPackage) self.homeConfigurations;
        # Uncomment the line to build an installer image
        # This is EXTREMELY LARGE and will make builds take forever
        # installer.x86_64-linux = nixosConfigurations.installer.config.system.build.isoImage;
      };
  };
}
