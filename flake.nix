rec {
  description = "Lotte's NixOS installation";

  # Use NixOS unstable
  inputs = {
    # Sorted by name
    attic = {
      url = "github:DarkKirb/attic";
      inputs.cargo2nix.follows = "cargo2nix";
      inputs.crane.follows = "crane";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
    };
    cargo2nix = {
      url = "github:DarkKirb/cargo2nix/release-0.11.0";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
    };
    crane = {
      url = "github:DarkKirb/crane";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
    };
    dns = {
      url = "github:DarkKirb/dns.nix";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:DarkKirb/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-neovim = {
      url = "github:syberant/nix-neovim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-packages = {
      url = "git+https://git.chir.rs/darkkirb/nix-packages.git?ref=main";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-config-for-netboot = {
      url = "github:DarkKirb/nixos-config/6ed9cdc5bd473f0cf4860ff001a11b7ea4b769f4";
      inputs.nixos-config-for-netboot.follows = "nixos-config-for-netboot";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nixpkgs.url = "github:NixOS/nixpkgs";
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
      {
        name = "vf2"; # VisionFive 2
        system = "riscv64-linux";
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
      riscv64-linux = import ./overlays args "riscv64-linux";
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
    packages.x86_64-linux = let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [
          self.overlays.x86_64-linux
          args.nix-packages.overlays.x86_64-linux.default
        ];
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
        overlays = [
          self.overlays.aarch64-linux
          args.nix-packages.overlays.aarch64-linux.default
        ];
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
    packages.riscv64-linux = let
      pkgs = import nixpkgs {
        system = "riscv64-linux";
        overlays = [
          self.overlays.riscv64-linux
          (import ./overlays/riscv.nix args)
          args.nix-packages.overlays.riscv64-linux.default
        ];
        config.allowUnfree = true;
      };
    in {
      neovim-base = args.nix-neovim.buildNeovim {
        inherit pkgs;
        configuration = import ./config/programs/vim/configuration.nix false;
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
