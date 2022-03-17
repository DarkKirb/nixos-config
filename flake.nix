{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs;
    flake-utils.url = github:numtide/flake-utils;

    flake-utils-plus = {
      url = github:gytis-ivaskevicius/flake-utils-plus;
      inputs.flake-utils.follows = "flake-utils";
    };

    nur.url = github:nix-community/NUR;
  };

  outputs = { self, nixpkgs, flake-utils-plus, nur, ... } @ inputs: flake-utils-plus.lib.mkFlake (
    let
      lib = nixpkgs.lib;
    in
    rec {
      inherit self inputs;

      channelsConfig = import ./config/nixpkgs.nix inputs;
      sharedOverlays = [
        nur.overlay
      ];

      hostDefaults.system = "x86_64-linux";
      hostDefaults.modules = [
        ./config
        (args: {
          imports = [
            (./hosts/${args.hostname})
          ];
          networking.hostName = args.hostname;
        })
      ];
      hostDefaults.specialArgs = inputs;

      outputsBuilder = import ./pkgs inputs;

      hosts.nixos-8gb-fsn1-1.specialArgs.hostname = "nixos-8gb-fsn1-1";
      hosts.nutty-noon.specialArgs.hostname = "nutty-noon";
      hosts.thinkrac.specialArgs.hostname = "thinkrac";

      hydraJobs = lib.attrsets.recursiveUpdate
        (lib.attrsets.mapAttrs (system: val: builtins.removeAttrs val [ "nixpkgs" ]) self.outputs.pkgs)
        (lib.attrsets.mapAttrs (_: val: val.config.system.build.toplevel) self.outputs.nixosConfigurations);
    }
  );
}
