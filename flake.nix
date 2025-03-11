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
      inputs.flake-parts.follows = "flake-parts";
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
      url = "github:DarkKirb/chir.rs";
      inputs.cargo2nix.follows = "cargo2nix";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
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
    gomod2nix = {
      url = "github:nix-community/gomod2nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    home-manager = {
      url = "github:DarkKirb/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hydra = {
      url = "git+https://git.lix.systems/lix-project/hydra";
      #inputs.lix.follows = "lix";
      #inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence = {
      url = "github:DarkKirb/impermanence/change-default-link-type";
    };
    jujutsu = {
      url = "github:jj-vcs/jj";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
    };
    lix = {
      url = "https://git.lix.systems/lix-project/lix/archive/2.92.0.tar.gz";
      inputs.flake-compat.follows = "flake-compat";
      inputs.nix2container.follows = "nix2container";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.pre-commit-hooks.follows = "pre-commit-hooks";
    };
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.92.0.tar.gz";
      inputs.flake-utils.follows = "flake-utils";
      inputs.flakey-profile.follows = "flakey-profile";
      inputs.lix.follows = "lix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-eval-jobs = {
      url = "git+https://git.lix.systems/lix-project/nix-eval-jobs.git";
      #inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions/a81daa13ca23440d8ae219d765140769c4d2f117";
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
    nixpkgs.url = "github:darkkirb/nixpkgs";
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
      gomod2nix,
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
          system = if system == "riscv64-linux" then "x86_64-linux" else system;
          crossSystem =
            if system == "riscv64-linux" then
              {
                inherit system;
              }
            else
              null;
          config.allowUnfree = true;
          config.permittedInsecurePackages = [ "olm-3.2.16" ];
          overlays = [
            (_: _: {
              inputs = inputs';
            })
            self.overlays.default
          ];
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
                system = args.targetSystem;
              };
              filteredArgs = filterAttrs (n: _: n != "targetSystem") args;
            in
            nixosSystem (
              filteredArgs
              // {
                specialArgs = args.specialArgs or { } // inputs';
              }
            );
          systems' = {
            instance-20221213-1915 = {
              config = ./machine/instance-20221213-1915;
              system = "aarch64-linux";
              variants = [
                "bg"
              ];
            };
            nas = {
              config = ./machine/nas;
              system = "x86_64-linux";
              variants = [
                "bg"
              ];
            };
            nixos-8gb-fsn1-1 = {
              config = ./machine/nixos-8gb-fsn1-1;
              system = "x86_64-linux";
              variants = [
                "bg"
              ];
            };
            not522 = {
              config = ./machine/not522;
              system = "x86_64-linux";
              targetSystem = "riscv64-linx";
              variants = [
                "bg"
              ];
            };
            not522-installer = {
              config = ./machine/not522/installer;
              system = "x86_64-linux";
              targetSystem = "riscv64-linx";
              variants = [
                "bg"
              ];
            };
            oracle-installer = {
              config = ./machine/oracle-installer;
              system = "aarch64-linux";
              variants = [
                "bg"
              ];
            };
            pc-installer = {
              config = ./machine/pc-installer;
              system = "x86_64-linux";
              variants = [
                "bg"
                "boot"
                "de"
              ];
            };
            rainbow-resort = {
              config = ./machine/rainbow-resort;
              system = "x86_64-linux";
              variants = [
                "bg"
                "boot"
                "de"
              ];
            };
            stinky-ssb = {
              config = ./machine/stinky-ssb;
              system = "aarch64-linux";
              variants = [
                "bg"
                "boot"
                "de"
              ];
            };
            thinkrac = {
              config = ./machine/thinkrac;
              system = "x86_64-linux";
              variants = [
                "bg"
                "boot"
                "de"
              ];
            };
          };
          mkVariant =
            system: variantCfg: variantName:
            let
              filteredVariantCfg = filterAttrs (n: _: elem n system.variants) variantCfg;
            in
            mkSystem {
              inherit (system) system;
              targetSystem = system.targetSystem or system.system;
              modules = [
                system.config
                (import ./variants/import-variants.nix filteredVariantCfg)
                {
                  nix.auto-update.variant = if variantName == "default" then null else variantName;
                }
              ];
            };

          mkVariantName = variantCfg: concatStringsSep "-" (attrValues variantCfg);
          permutations = import ./variants/permutations.nix { inherit (nixpkgs) lib; };
          variantCfgs = system: permutations system.variants;
          mkVariants =
            hostname: system:
            (map (
              variantCfg:
              let
                variantName = mkVariantName variantCfg;
              in
              {
                name = "${hostname}-${variantName}";
                value = mkVariant system variantCfg variantName;
              }
            ) (variantCfgs system))
            ++ [
              {
                name = hostname;
                value = mkVariant system (import ./variants/defaults.nix) null;
              }
            ];

          systems = listToAttrs (flatten (mapAttrsToList mkVariants systems'));
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
            treefmt
            dtc
          ];
        };
      formatter.x86_64-linux = (pkgsFor "x86_64-linux").nixfmt-rfc-style;
      overlays = rec {
        cross-packages = import ./overlays/crossPackages.nix inputs;
        gomod2nix = inputs.gomod2nix.overlays.default;
        jujutsu = inputs.jujutsu.overlays.default;
        lix = inputs.lix.overlays.default;
        nix-gaming = inputs.nix-gaming.overlays.default;
        nix-vscode-extensions = inputs.nix-vscode-extensions.overlays.default;
        no-x-libs = import ./overlays/no-x-libs.nix;
        packages = import ./overlays/packages.nix inputs;
        rust-overlay = import inputs.rust-overlay;
        workarounds = import ./overlays/workarounds.nix;
        default = nixpkgs.lib.composeManyExtensions [
          # gomod2nix is required by the packages overlay
          gomod2nix
          jujutsu
          lix
          nix-gaming
          nix-vscode-extensions
          packages
          rust-overlay
          workarounds
        ];
        riscv64-linux = nixpkgs.lib.composeManyExtensions [
          no-x-libs
          cross-packages
        ];
      };
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
                  package-updater
                  yiffstash
                  emoji-caro
                  emoji-lotte
                  emoji-volpeon-blobfox
                  emoji-volpeon-bunhd
                  emoji-volpeon-drgn
                  emoji-volpeon-floof
                  emoji-volpeon-fox
                  emoji-volpeon-gphn
                  emoji-volpeon-neocat
                  emoji-volpeon-neofox
                  emoji-volpeon-raccoon
                  emoji-volpeon-vlpn
                  emoji-volpeon-wvrn
                  emoji-rosaflags
                  emoji-neopossum
                  gomod2nix
                  clscrobble
                  tulir-telethon
                  mautrix-python
                  mautrix-telegram
                  mautrix-discord
                  mautrix-slack
                  mautrix-whatsapp
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
# Trick renovate into working: "github:NixOS/nixpkgs/nixpkgs-unstable"
