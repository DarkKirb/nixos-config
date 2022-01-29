rec {
  description = "Lotte's NixOS installation";

  # Use NixOS unstable
  inputs.nixpkgs.url = "github:DarkKirb/nixpkgs?ref=soundtouch-2.3.1";
  inputs.home-manager.url = "github:nix-community/home-manager";
  inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";
  inputs.sops-nix.url = github:Mic92/sops-nix;
  inputs.sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  inputs.chir-rs.url = "git+https://git.chir.rs/darkkirb/chir.rs.git?ref=main";
  #inputs.chir-rs.inputs.nixpkgs.follows = "nixpkgs"; # nixpkgs regression?
  inputs.nur.url = "github:nix-community/NUR";
  inputs.nix-gaming.url = github:fufexan/nix-gaming;
  inputs.nix-gaming.inputs.nixpkgs.follows = "nixpkgs";
  inputs.polymc.url = "github:PolyMC/PolyMC";
  inputs.polymc.inputs.nixpkgs.follows = "nixpkgs";
  inputs.dns.url = "github:DarkKirb/dns.nix";
  inputs.dns.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { self, nixpkgs, sops-nix, home-manager, chir-rs, nur, nix-gaming, polymc, ... } @ args: {
    nixosConfigurations =
      let
        systems = [
          "nixos-8gb-fsn1-1" # Hetzner Server
          "nutty-noon" # PC
          "thinkrac" # Thinkpad T470
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
                ({ pkgs, ... }: {
                  nixpkgs.overlays = [
                    (self: super: {
                      chir-rs = chir-rs.outputs.defaultPackage.x86_64-linux;
                      nix-gaming = nix-gaming.outputs.packages.x86_64-linux;
                    })
                    nur.overlay
                    polymc.overlay
                  ];
                })
              ];
            };
        })
        systems);
  };
}

