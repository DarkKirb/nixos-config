{
  description = "Lotte’s nix configuration";

  inputs = {
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
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
      url = "github:nix-community/impermanence";
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
    nix2container = {
      url = "github:nlewo/nix2container";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nixpkgs.url = "github:nixos/nixpkgs";
    nur.url = "github:nix-community/NUR";
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
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };
    systems.url = "github:nix-systems/default";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs': let
    inputs =
      inputs'
      // {
        nixos-config = self;
        inherit inputs;
        inTester = false;
        pureInputs = inputs';
      };
    pkgsFor = system: let
      inputs' =
        inputs
        // {
          inherit system;
          inputs = inputs';
        };
    in
      import nixpkgs {
        inherit system;
        overlays =
          [
            (_: _:
              inputs'
              // {
                inputs = inputs';
              })
          ]
          ++ (
            if system == "riscv64-linux"
            then [
              inputs.riscv-overlay.overlays.default
            ]
            else []
          );
      };
  in {
    checks.x86_64-linux = nixpkgs.lib.listToAttrs (map (testName: {
      name = testName;
      value = (pkgsFor "x86_64-linux").callPackage ./tests/${testName}.nix {};
    }) ["containers-default"]);
    nixosModules = {
      containers = import ./modules/containers/default.nix;
      default = import ./modules/default.nix;
    };
    nixosContainers = with nixpkgs.lib; let
      containerNames = [
        "default"
      ];
      containerArches = ["x86_64-linux" "aarch64-linux" "riscv64-linux"];
      containers = listToAttrs (flatten (map (system: let
        pkgs = pkgsFor system;
      in
        map (container: {
          name = "container-${container}-${system}";
          value = pkgs.callPackage ./containers/${container}-configuration.nix {};
        })
        containerNames)
      containerArches));
    in
      containers;
    nixosConfigurations = with nixpkgs.lib; let
      mkSystem = args: let
        inputs' = inputs // {inherit (args) system;};
      in
        nixosSystem (args
          // {
            specialArgs =
              args.specialArgs
              or {}
              // inputs';
          });
      systems' = {
        not522 = {
          config = ./machine/not522;
          system = "riscv64-linux";
        };
        not522-installer = {
          config = ./machine/not522/installer;
          system = "riscv64-linux";
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
      containers = mapAttrs (_: container:
        mkSystem {
          inherit (container) system;
          modules = [
            container.config
          ];
        })
      self.nixosContainers;
      systems = mapAttrs (_: system:
        mkSystem {
          inherit (system) system;
          modules = [
            system.config
          ];
        })
      systems';
    in
      containers // systems;
    hydraJobs = {
      inherit (self) checks devShells;
      nixosConfigurations = nixpkgs.lib.mapAttrs (_: v: v.config.system.build.toplevel) self.nixosConfigurations;
    };
    devShells.x86_64-linux.default = with pkgsFor "x86_64-linux";
      mkShell {
        nativeBuildInputs = with pkgs; [
          age
          sops
          ssh-to-age
        ];
      };
  };
}
