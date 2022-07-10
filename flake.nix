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
    inherit (inputs.utils.lib) exportOverlays exportPackages exportModules;
  in
    inputs.utils.lib.mkFlake {
      inherit inputs;
      inherit (inputs) self;

      supportedSystems = ["x86_64-linux"];

      channelsConfig = {
        allowUnfree = true;
        contentAddressedByDefault = true;
      };
      sharedOverlays = with inputs; [
        nur.overlay
        self.overlay
      ];
      overlay = import ./overlays;
      # export overlays automatically for all packages defined in overlaysBuilder of each channel
      overlays = exportOverlays {
        inherit (inputs.self) pkgs inputs;
      };
      outputsBuilder = channels: rec {
        # construct packagesBuilder to export all packages defined in overlays
        packages = exportPackages inputs.self.overlays channels // devShells;

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
