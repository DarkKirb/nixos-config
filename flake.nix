rec {
  description = "Lotte's NixOS installation";

  # Use NixOS unstable
  inputs.nixpkgs.url = github:NixOS/nixpkgs;
  inputs.nixpkgs-soundtouch.url = "github:darkkirb/nixpkgs?ref=soundtouch-2.3.1";
  inputs.nixpkgs-tdesktop.url = "github:yshym/nixpkgs?ref=tdesktop-3.5.1";
  inputs.cargo2nix.url = "github:cargo2nix/cargo2nix/master"; # dummy
  inputs.home-manager.url = "github:nix-community/home-manager";
  inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";
  inputs.sops-nix.url = github:Mic92/sops-nix;
  inputs.sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  inputs.chir-rs.url = "git+https://git.chir.rs/darkkirb/chir.rs.git?ref=main";
  #inputs.chir-rs.inputs.nixpkgs.follows = "nixpkgs"; # nixpkgs regression?
  inputs.nur.url = "github:nix-community/NUR";
  inputs.nix-gaming.url = github:fufexan/nix-gaming;
  #inputs.nix-gaming.inputs.nixpkgs.follows = "nixpkgs"; # rebuilds wine-tkg literally every goddamn time
  inputs.polymc.url = "github:PolyMC/PolyMC";
  inputs.polymc.inputs.nixpkgs.follows = "nixpkgs";
  inputs.dns.url = "github:DarkKirb/dns.nix?ref=master";
  inputs.dns.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { self, nixpkgs, sops-nix, home-manager, chir-rs, nur, nix-gaming, polymc, ... } @ args:
    let
      systems = [
        {
          name = "nixos-8gb-fsn1-1"; # Hetzner Server
          system = "x86_64-linux";
        }
        {
          name = "nutty-noon"; # PC
          system = "x86_64-linux";
        }
        {
          name = "thinkrac"; # Thinkpad T470
          system = "x86_64-linux";
        }
        {
          name = "rpi2"; # Raspberry Pi 2
          system = "armv7l-linux";
        }
      ];
    in
    rec {
      nixosConfigurations =
        builtins.listToAttrs (map
          ({ name, system }: {
            inherit name;
            value = nixpkgs.lib.nixosSystem
              {
                inherit system;
                specialArgs = args // {
                  inherit system;
                };
                modules = [
                  (./config + "/${name}.nix")
                  ./config/default.nix
                  sops-nix.nixosModules.sops
                  home-manager.nixosModules.home-manager
                  ({ pkgs, ... }: {
                    nixpkgs.overlays = [
                      (self: super: {
                        chir-rs = chir-rs.outputs.defaultPackage.${system};
                        nix-gaming = nix-gaming.outputs.packages.${system};
                      })
                      nur.overlay
                      polymc.overlay
                    ];
                  })
                ];
              };
          })
          systems);
      hydraJobs = builtins.listToAttrs (map
        ({ name, system }: {
          inherit name;
          value = {
            ${system} = nixosConfigurations.${name}.config.system.build.toplevel;
          };
        })
        systems);
    };
}

