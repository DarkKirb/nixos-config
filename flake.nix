rec {
  description = "Lotte's NixOS installation";

  # Use NixOS unstable
  inputs.nixpkgs.url = "github:nixos/nixpkgs";
  inputs.home-manager.url = "github:nix-community/home-manager";
  inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";
  inputs.sops-nix.url = github:Mic92/sops-nix;
  inputs.sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  inputs.chir-rs.url = "git+https://git.chir.rs/darkkirb/chir.rs.git?ref=main";
  inputs.chir-rs.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { self, nixpkgs, sops-nix, home-manager, chir-rs, ... } @ args: {
    nixosConfigurations =
      let
        systems = [
          "nixos-8gb-fsn1-1" # Hetzner Server
        ];
      in
      builtins.listToAttrs (map
        (name: {
          name = name;
          value = nixpkgs.lib.nixosSystem
            {
              system = "x86_64-linux";
              modules = [
                (./config + "/${name}.nix")
                ./config/default.nix
                sops-nix.nixosModules.sops
                home-manager.nixosModules.home-manager
              ];
              inherit chir-rs;
            };
        })
        systems);
  };
}

