{
  description = "Lotte’s nix configuration";

  inputs = {
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    element-web = {
      url = "github:darkkirb/element-web";
      inputs.devshell.follows = "devshell";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-parts.follows = "flake-parts";
      inputs.matrix-js-sdk.follows = "matrix-js-sdk";
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
    matrix-js-sdk = {
      url = "github:darkkirb/matrix-js-sdk";
      inputs.devshell.follows = "devshell";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-parts.follows = "flake-parts";
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
      inputs.nixpkgs-stable.follows = "nixpkgs";
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
      inputs.nixpkgs-stable.follows = "nixpkgs";
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
            not522 = {
              config = ./machine/not522;
              system = "x86_64-linux";
            };
            not522-installer = {
              config = ./machine/not522/installer;
              system = "x86_64-linux";
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
      overlays.default = import ./packages;
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
                  art-lotte-bgs-nsfw
                  art-lotte-bgs-sfw
                  fish
                  package-updater
                  ;
              }
              // (
                if name != "riscv64-linux" then
                  {
                    inherit (pkgs)
                      element-desktop
                      element-web
                      kodi-joyn
                      ;
                  }
                else
                  { }
              );
          })
          [
            "x86_64-linux"
            #"riscv64-linux"
            "aarch64-linux"
          ]
      );
    };
}
