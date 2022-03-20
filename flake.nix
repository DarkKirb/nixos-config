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

    sops-nix = {
      url = github:Mic92/sops-nix;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neo2 = {
      url = "git+https://git.neo-layout.org/neo/neo-layout";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils-plus, nur, sops-nix, ... } @ inputs: flake-utils-plus.lib.mkFlake (
    let
      lib = nixpkgs.lib;
    in
    rec {
      inherit self inputs;

      channelsConfig = import ./config/nixpkgs.nix inputs;
      sharedOverlays = [
        nur.overlay
        sops-nix.overlay
        (super: _: {
          darkkirb = self.packages.${super.system};
        })
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
        sops-nix.nixosModules.sops
      ];
      hostDefaults.specialArgs = inputs;

      outputsBuilder = import ./pkgs inputs;

      hosts.nixos-8gb-fsn1-1.specialArgs.hostname = "nixos-8gb-fsn1-1";
      hosts.nutty-noon.specialArgs.hostname = "nutty-noon";
      hosts.thinkrac.specialArgs.hostname = "thinkrac";

      hydraJobs =
        (builtins.removeAttrs self.packages [ "aarch64-darwin" "x86_64-darwin" ]) //
        (lib.attrsets.mapAttrs (_: val: val.config.system.build.toplevel) self.outputs.nixosConfigurations);
    }
  );
}
