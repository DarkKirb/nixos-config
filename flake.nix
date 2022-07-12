{
  description = "Work-in-progress nixos configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    nur.url = "github:nix-community/NUR";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        utils.follows = "flake-utils";
      };
    };

    utils = {
      url = "github:gytis-ivaskevicius/flake-utils-plus";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = inputs: let
    inherit (inputs.nixpkgs.lib.attrsets) mapAttrsToList;
    inherit (inputs.utils.lib) exportOverlays exportPackages exportModules;
  in
    inputs.utils.lib.mkFlake {
      inherit inputs;
      inherit (inputs) self;

      supportedSystems = ["x86_64-linux"];

      hostDefaults = {
        system = "x86_64-linux";
        modules =
          [
            ./config
            inputs.home-manager.nixosModules.home-manager
          ]
          ++ (mapAttrsToList (_: a: a) inputs.self.modules);
        extraArgs = {inherit inputs;};
      };

      hosts = {
        installer.modules = [./hosts/installer];
        nas.modules = [./hosts/nas];
        nixos-8gb-fsn1-1.modules = [./hosts/nixos-8gb-fsn1-1];
        nutty-noon.modules = [./hosts/nutty-noon];
        thinkrac.modules = [./hosts/thinkrac];
      };

      channelsConfig = {
        allowUnfree = true;
        contentAddressedByDefault = true;
      };
      sharedOverlays = with inputs; [
        nur.overlay
        self.overlay
      ];
      overlay = import ./overlays;
      modules = inputs.utils.lib.exportModules [
        ./modules/zfs.nix
      ];
      # export overlays automatically for all packages defined in overlaysBuilder of each channel
      overlays = exportOverlays {
        inherit (inputs.self) pkgs inputs;
      };
      outputsBuilder = channels: let
        inherit (channels.nixpkgs) lib;
        filteredConfigs = lib.attrsets.filterAttrs (_: value: value.config.nixpkgs.system == channels.nixpkgs.system) inputs.self.nixosConfigurations;
        mappedConfigs = builtins.mapAttrs (_: value: value.config.system.build.toplevel) filteredConfigs;
      in rec {
        # construct packagesBuilder to export all packages defined in overlays
        packages = exportPackages inputs.self.overlays channels // devShells // mappedConfigs;

        devShells = rec {
          devShell = with channels.nixpkgs;
            mkShell {
              nativeBuildInputs = [
                sops
                ssh-to-age
                nix-prefetch
                jq
                statix
                fup-repl
                alejandra
              ];
            };
          default = devShell;
        };
        hydraJobs = packages;
        formatter = channels.nixpkgs.alejandra;
      };
    };
}
