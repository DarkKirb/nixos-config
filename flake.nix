{
  description = "Lotte’s nix configuration";

  inputs = {
    admin-fe = {
      url = "github:DarkKirb/admin-fe";
      inputs.devshell.follows = "devshell";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-parts.follows = "flake-parts";
      #inputs.nixpkgs.follows = "nixpkgs";
    };
    akkoma = {
      url = "github:DarkKirb/akkoma";
      inputs.devshell.follows = "devshell";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-parts.follows = "flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    akkoma-fe = {
      url = "github:DarkKirb/akkoma-fe";
      inputs.devshell.follows = "devshell";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-parts.follows = "flake-parts";
      #inputs.nixpkgs.follows = "nixpkgs";
    };
    attic = {
      url = "github:DarkKirb/attic";
      inputs.crane.follows = "crane";
      inputs.flake-compat.follows = "flake-compat";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    cargo2nix = {
      url = "github:DarkKirb/cargo2nix/master";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
    };
    chir-rs = {
      url = "git+https://git.chir.rs/darkkirb/chir.rs";
      inputs.cargo2nix.follows = "cargo2nix";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
      inputs.riscv-overlay.follows = "riscv-overlay";
    };
    crane = {
      url = "github:DarkKirb/crane";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
    };
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dns = {
      url = "github:DarkKirb/dns.nix";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
    flakey-profile = {
      url = "github:lf-/flakey-profile";
    };
    gitignore = {
      url = "github:hercules-ci/gitignore.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hydra = {
      url = "git+https://git.lix.systems/lix-project/hydra";
      #inputs.lix.follows = "lix";
      #inputs.nix-eval-jobs.follows = "nix-eval-jobs";
      #inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence = {
      url = "github:DarkKirb/impermanence/change-default-link-type";
    };
    lix = {
      url = "git+https://git.lix.systems/lix-project/lix";
      inputs.flake-compat.follows = "flake-compat";
      inputs.nix2container.follows = "nix2container";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.pre-commit-hooks.follows = "pre-commit-hooks";
    };
    lix-module = {
      url = "git+https://git.lix.systems/lix-project/nixos-module";
      inputs.flake-utils.follows = "flake-utils";
      inputs.flakey-profile.follows = "flakey-profile";
      inputs.lix.follows = "lix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-eval-jobs = {
      url = "git+https://git.lix.systems/lix-project/nix-eval-jobs.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix2container = {
      url = "github:nlewo/nix2container";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nixpkgs.url = "github:nixos/nixpkgs";
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.flake-compat.follows = "flake-compat";
      inputs.gitignore.follows = "gitignore";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    riscv-overlay = {
      url = "github:DarkKirb/riscv-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rycee-nur-expressions = {
      url = "git+https://gitlab.com/rycee/nur-expressions";
      flake = false;
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:DarkKirb/stylix";
      inputs.home-manager.follows = "home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    systems.url = "github:nix-systems/default";
    vscode-server = {
      url = "github:nix-community/nixos-vscode-server";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }@inputs':
    let
      inputs = inputs' // {
        nixos-config = self;
        inherit inputs;
        inTester = false;
        pureInputs = inputs';
      };
      pkgsFor =
        system:
        let
          inputs' = inputs // {
            inherit system;
            inputs = inputs';
          };
        in
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays =
            [
              (_: _: {
                inputs = inputs';
              })
              self.overlays.default
            ]
            ++ (
              if system == "riscv64-linux" then
                [
                  inputs.riscv-overlay.overlays.default
                ]
              else
                [ ]
            );
        };
    in
    {
      nixosModules = {
        default = import ./modules/default.nix;
      };
      nixosConfigurations =
        with nixpkgs.lib;
        let
          mkSystem =
            args:
            let
              inputs' = inputs // {
                inherit (args) system;
              };
            in
            nixosSystem (
              args
              // {
                specialArgs = args.specialArgs or { } // inputs';
              }
            );
          systems' = {
            instance-20221213-1915 = {
              config = ./machine/instance-20221213-1915;
              system = "aarch64-linux";
            };
            nas = {
              config = ./machine/nas;
              system = "x86_64-linux";
            };
            nixos-8gb-fsn1-1 = {
              config = ./machine/nixos-8gb-fsn1-1;
              system = "x86_64-linux";
            };
            not522 = {
              config = ./machine/not522;
              system = "riscv64-linux";
            };
            not522-installer = {
              config = ./machine/not522/installer;
              system = "riscv64-linux";
            };
            oracle-installer = {
              config = ./machine/oracle-installer;
              system = "aarch64-linux";
            };
            pc-installer = {
              config = ./machine/pc-installer;
              system = "x86_64-linux";
            };
            rainbow-resort = {
              config = ./machine/rainbow-resort;
              system = "x86_64-linux";
            };
            stinky-ssb = {
              config = ./machine/stinky-ssb;
              system = "aarch64-linux";
            };
            thinkrac = {
              config = ./machine/thinkrac;
              system = "x86_64-linux";
            };
          };
          systems = mapAttrs (
            _: system:
            mkSystem {
              inherit (system) system;
              modules = [
                system.config
              ];
            }
          ) systems';
        in
        systems;
      hydraJobs = {
        inherit (self) devShells packages;
        nixosConfigurations = nixpkgs.lib.mapAttrs (
          _: v: v.config.system.build.toplevel
        ) self.nixosConfigurations;
      };
      devShells.x86_64-linux.default =
        with pkgsFor "x86_64-linux";
        mkShell {
          nativeBuildInputs = with pkgs; [
            age
            sops
            ssh-to-age
            nixfmt-rfc-style
            nix-prefetch
            nix-prefetch-git
          ];
        };
      formatter.x86_64-linux = (pkgsFor "x86_64-linux").nixfmt-rfc-style;
      overlays.default = import ./packages inputs;
      packages = nixpkgs.lib.listToAttrs (
        map
          (name: {
            inherit name;
            value =
              let
                pkgs = pkgsFor name;
              in
              {
                inherit (pkgs)
                  art-lotte
                  fish
                  package-updater
                  yiffstash
                  ;
              }
              // (
                if name != "riscv64-linux" then
                  {
                    inherit (pkgs)
                      fcitx5-configtool
                      fcitx5-table-extra
                      kodi-joyn
                      palette-generator
                      palettes
                      plover
                      plover_dict_commands
                      plover-env
                      plover_lapwing_aio
                      plover_last_translation
                      plover_modal_dictionary
                      plover_plugins_manager
                      plover_python_dictionary
                      plover_stitching
                      plover_stroke
                      plover_uinput
                      rtf_tokenize
                      ;
                  }
                else
                  { }
              )
              // (
                if name == "aarch64-linux" then
                  {
                    inherit (pkgs) linux-devterm;
                  }
                else
                  { }
              );
          })
          [
            "x86_64-linux"
            "riscv64-linux"
            "aarch64-linux"
          ]
      );
    };
}
