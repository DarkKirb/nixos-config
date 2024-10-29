{
  description = "Lotte’s nix configuration";

  inputs = {
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
    nixpkgs.url = "github:nixos/nixpkgs";
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
      containers = mapAttrs (_: container:
        mkSystem {
          inherit (container) system;
          modules = [
            container.config
          ];
        })
      self.nixosContainers;
    in
      containers;
    hydraJobs = {
      inherit (self) checks;
      nixosConfigurations = nixpkgs.lib.mapAttrs (_: v: v.config.system.build.toplevel) self.nixosConfigurations;
    };
  };
}
