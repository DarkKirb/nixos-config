rec {
  description = "Lotte's NixOS installation";

  # Use NixOS unstable
  inputs = {
    # Sorted by name
    attic = {
      url = "github:DarkKirb/attic";
      inputs.crane.follows = "crane";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs-for-crane";
      inputs.nixpkgs-stable.follows = "nixpkgs-for-crane";
    };
    cargo2nix = {
      url = "github:DarkKirb/cargo2nix/release-0.11.0";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
    };
    chir-rs = {
      url = "github:DarkKirb/chir.rs";
      inputs.cargo2nix.follows = "cargo2nix";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
    };
    colorpickle = {
      url = "github:AgathaSorceress/colorpickle";
      inputs.naersk.follows = "naersk";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "flake-utils";
    };
    crane = {
      url = "github:DarkKirb/crane";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs-for-crane";
      inputs.rust-overlay.follows = "rust-overlay";
    };
    dns = {
      url = "github:DarkKirb/dns.nix";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emanote = {
      url = "github:EmaApps/emanote";
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
    naersk = {
      url = "github:nix-community/naersk/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-neovim = {
      url = "github:syberant/nix-neovim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-packages = {
      url = "git+https://git.chir.rs/darkkirb/nix-packages.git?ref=main";
      inputs.attic.follows = "attic";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-config-for-netboot = {
      url = "github:DarkKirb/nixos-config/09d7bc6e18f5570522c1c6ba1c6a9db27f933c7a";
      inputs.nixos-config-for-netboot.follows = "nixos-config-for-netboot";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nixpkgs.url = "github:NixOS/nixpkgs";
    nixpkgs-for-crane.url = "github:NixOS/nixpkgs/3ae365afb80773c3bb67e52294a82e329a9e5be0";
    nur.url = "github:nix-community/NUR";
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
    nixpkgsFor = system:
      import ./utils/patched-nixpkgs.nix {
        inherit nixpkgs system;
        patches = [./extra/nixpkgs.patch];
      };
    pkgsFor = system:
      import (nixpkgsFor system) {
        localSystem.system = system;
        overlays = [
          self.overlays.${system}
          nur.overlay
          args.prismmc.overlay
        ];
        config.allowUnfree = true;
      };
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
        name = "installer"; # Installer iso
        system = "x86_64-linux";
      }
      {
        name = "netboot"; # Installer netboot
        system = "x86_64-linux";
      }
      {
        name = "instance-20221213-1915"; # Oracle server
        system = "aarch64-linux";
      }
    ];
  in rec {
    nixosConfigurations = builtins.listToAttrs (map
      ({
        name,
        system,
        configName ? name,
      }: let
        nixpkgs' = nixpkgsFor system;
        pkgs = pkgsFor system;
        nixosSystem = import "${nixpkgs'}/nixos/lib/eval-config.nix";
      in {
        inherit name;
        value =
          nixosSystem
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
                ];
                home-manager.extraSpecialArgs = args // {inherit system;};
              })
              (import utils/link-input.nix args)
              {
                system.nixos.versionSuffix = ".${pkgs.lib.substring 0 8 (self.lastModifiedDate or self.lastModified or "19700101")}.${self.shortRev or "dirty"}";
                system.nixos.revision = pkgs.lib.mkIf (nixpkgs ? rev) nixpkgs.rev;
              }
            ];
          };
      })
      systems);
    overlays = {
      x86_64-linux = import ./overlays args "x86_64-linux";
      aarch64-linux = import ./overlays args "aarch64-linux";
    };
    devShell.x86_64-linux = let
      pkgs = pkgsFor "x86_64-linux";
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
    packages.x86_64-linux = let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [self.overlays.x86_64-linux];
        config.allowUnfree = true;
      };
    in {
      neovim-base = args.nix-neovim.buildNeovim {
        inherit pkgs;
        configuration = import ./config/programs/vim/configuration.nix false;
      };
      neovim = args.nix-neovim.buildNeovim {
        inherit pkgs;
        configuration = import ./config/programs/vim/configuration.nix true;
      };
    };
    packages.aarch64-linux = let
      pkgs = import nixpkgs {
        system = "aarch64-linux";
        overlays = [self.overlays.aarch64-linux];
        config.allowUnfree = true;
      };
    in {
      neovim-base = args.nix-neovim.buildNeovim {
        inherit pkgs;
        configuration = import ./config/programs/vim/configuration.nix false;
      };
      neovim = args.nix-neovim.buildNeovim {
        inherit pkgs;
        configuration = import ./config/programs/vim/configuration.nix true;
      };
    };
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
        inherit packages;
        # Uncomment the line to build an installer image
        # This is EXTREMELY LARGE and will make builds take forever
        # installer.x86_64-linux = nixosConfigurations.installer.config.system.build.isoImage;
      };
  };
}
