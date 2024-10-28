{
  description = "Lotte’s nix configuration";

  inputs = {
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    nixpkgs.url = "github:nixos/nixpkgs";
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
    pkgsFor = system:
      import nixpkgs {
        inherit system;
        overlays = [
          (_: _:
            inputs
            // {
              inherit inputs;
            })
        ];
      };
  in {
    checks.x86_64-linux = nixpkgs.lib.listToAttrs (map (testName: {
      name = testName;
      value = (pkgsFor "x86_64-linux").callPackage ./tests/${testName}.nix {};
    }) ["containers-default"]);
    nixosModules = {
      containers = import ./modules/containers/default.nix;
      containers-autoconfig = import ./modules/containers/autoconfig.nix;
    };
    nixosContainers = with nixpkgs.lib; let
      containerNames = [
        "default"
      ];
      containerArches = ["x86_64-linux" "aarch64-linux"];
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
      mkSystem = args:
        nixosSystem (args
          // {
            specialArgs =
              args.specialArgs
              or {}
              // inputs;
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
