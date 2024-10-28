{
  description = "Lotte’s nix configuration";

  inputs = {
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    nixpkgs.url = "github:nixos/nixpkgs";
    riscv-overlay = {
      url = "github:DarkKirb/riscv-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
