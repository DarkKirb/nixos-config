{
  description = "Lotte’s nix configuration";

  inputs = {
    admin-fe = {
      url = "github:DarkKirb/admin-fe/76424b7fe477b5a81b2961e6e8742a12b441f3d3";
      inputs.devshell.follows = "devshell";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-parts.follows = "flake-parts";
      #inputs.nixpkgs.follows = "nixpkgs";
    };
    akkoma = {
      url = "github:DarkKirb/akkoma/0383ea0469a723c8992e03b41554cf9e0a165b15";
      inputs.devshell.follows = "devshell";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-parts.follows = "flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    akkoma-fe = {
      url = "github:DarkKirb/akkoma-fe/b1ed0f54f94c8c673712b433faf4e62af3f9624c";
      inputs.devshell.follows = "devshell";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-parts.follows = "flake-parts";
      #inputs.nixpkgs.follows = "nixpkgs";
    };
    attic = {
      url = "github:DarkKirb/attic/bf3bd0755c5e312787a6b72c1d0b6d7272c239bb";
      inputs.crane.follows = "crane";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-parts.follows = "flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    cargo2nix = {
      url = "github:DarkKirb/cargo2nix/29084d950413d317ce5c5901d5f5fd3510a38974";
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
    };
    crane = {
      url = "github:DarkKirb/crane/42c3f329daa267857c6bc6d21c9eec468e97e2d7";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
    };
    devshell = {
      url = "github:numtide/devshell/f7795ede5b02664b57035b3b757876703e2c3eac";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko/ff3568858c54bd306e9e1f2886f0f781df307dff";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dns = {
      url = "github:DarkKirb/dns.nix/4d3d32b0fd221895bf3da0e348056260c3a77636";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-compat = {
      url = "github:edolstra/flake-compat/ff81ac966bb2cae68946d5ed5fc4994f96d0ffec";
      flake = false;
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts/32ea77a06711b758da0ad9bd6a844c5740a87abd";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    flake-utils = {
      url = "github:numtide/flake-utils/11707dc2f618dd54ca8739b309ec4fc024de578b";
      inputs.systems.follows = "systems";
    };
    flakey-profile = {
      url = "github:lf-/flakey-profile/243c903fd8eadc0f63d205665a92d4df91d42d9d";
    };
    gitignore = {
      url = "github:hercules-ci/gitignore.nix/637db329424fd7e46cf4185293b9cc8c88c95394";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/947eef9e99c42346cf0aac2bebe1cd94924c173b";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hydra = {
      url = "git+https://git.lix.systems/lix-project/hydra";
      #inputs.lix.follows = "lix";
      inputs.nix-eval-jobs.follows = "nix-eval-jobs";
      #inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence = {
      url = "github:DarkKirb/impermanence/5edca6851b3b65d02cdd68e766ffb7162e17e730";
    };
    jujutsu = {
      url = "github:jj-vcs/jj/6d6f2c6deccfb6d2fe535df01af835c31a6fe10d";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
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
      #inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
    nix-gaming = {
      url = "github:fufexan/nix-gaming/3030553160ece3b8ea7df66d2670e8f41f0c0ec7";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions/6457c8c71e998d76799e0a246dd6a2ca13ffe51d";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix2container = {
      url = "github:nlewo/nix2container/5fb215a1564baa74ce04ad7f903d94ad6617e17a";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/2eccff41bab80839b1d25b303b53d339fbb07087";
    nixpkgs.url = "github:nixos/nixpkgs/9e708797a87ae1e05456987cd1359fe7d5225588";
    plasma-manager = {
      url = "github:nix-community/plasma-manager/a53af7f1514ef4cce8620a9d6a50f238cdedec8b";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix/9364dc02281ce2d37a1f55b6e51f7c0f65a75f17";
      inputs.flake-compat.follows = "flake-compat";
      inputs.gitignore.follows = "gitignore";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    riscv-overlay = {
      url = "github:DarkKirb/riscv-overlay/4db935dcc65c04985bef87c49532e6358fe27503";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay/5c571e5ff246d8fc5f76ba6e38dc8edb6e4002fe";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rycee-nur-expressions = {
      url = "git+https://gitlab.com/rycee/nur-expressions";
      flake = false;
    };
    sops-nix = {
      url = "github:Mic92/sops-nix/4c1251904d8a08c86ac6bc0d72cc09975e89aef7";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:DarkKirb/stylix/24459d4a58e94df886697508ca2cea0c2ca2688a";
      inputs.home-manager.follows = "home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    systems.url = "github:nix-systems/default/da67096a3b9bf56a91d16901293e51ba5b49a27e";
    vscode-server = {
      url = "github:nix-community/nixos-vscode-server/8b6db451de46ecf9b4ab3d01ef76e59957ff549f";
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
          system = if system == "riscv64-linux" then "x86_64-linux" else system;
          crossSystem =
            if system == "riscv64-linux" then
              {
                inherit system;
              }
            else
              null;
          config.allowUnfree = true;
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
                "polarity"
              ];
            };
            nas = {
              config = ./machine/nas;
              system = "x86_64-linux";
              variants = [
                "bg"
                "polarity"
              ];
            };
            nixos-8gb-fsn1-1 = {
              config = ./machine/nixos-8gb-fsn1-1;
              system = "x86_64-linux";
              variants = [
                "bg"
                "polarity"
              ];
            };
            not522 = {
              config = ./machine/not522;
              system = "x86_64-linux";
              targetSystem = "riscv64-linx";
              variants = [
                "bg"
                "polarity"
              ];
            };
            not522-installer = {
              config = ./machine/not522/installer;
              system = "x86_64-linux";
              targetSystem = "riscv64-linx";
              variants = [
                "bg"
                "polarity"
              ];
            };
            oracle-installer = {
              config = ./machine/oracle-installer;
              system = "aarch64-linux";
              variants = [
                "bg"
                "polarity"
              ];
            };
            pc-installer = {
              config = ./machine/pc-installer;
              system = "x86_64-linux";
              variants = [
                "bg"
                "boot"
                "de"
                "polarity"
              ];
            };
            rainbow-resort = {
              config = ./machine/rainbow-resort;
              system = "x86_64-linux";
              variants = [
                "bg"
                "boot"
                "de"
                "polarity"
              ];
            };
            stinky-ssb = {
              config = ./machine/stinky-ssb;
              system = "aarch64-linux";
              variants = [
                "bg"
                "boot"
                "de"
                "polarity"
              ];
            };
            thinkrac = {
              config = ./machine/thinkrac;
              system = "x86_64-linux";
              variants = [
                "bg"
                "boot"
                "de"
                "polarity"
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
# Trick renovate into working: "github:NixOS/nixpkgs/nixpkgs-unstable"
