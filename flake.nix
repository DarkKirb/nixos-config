rec {
  description = "Lotte's NixOS installation";

  # Use NixOS unstable
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs;
    flake-utils.url = github:numtide/flake-utils;
    home-manager.url = "github:andresilva/home-manager/fix-systemd-services";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = github:Mic92/sops-nix;
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    chir-rs.url = "git+https://git.chir.rs/darkkirb/chir.rs.git?ref=main";
    nur.url = "github:nix-community/NUR";
    polymc.url = "github:PolyMC/PolyMC";
    polymc.inputs.nixpkgs.follows = "nixpkgs";
    dns.url = "github:DarkKirb/dns.nix?ref=master";
    hydra.url = github:NixOS/hydra;
    nixpkgs-hydra.url = "github:NixOS/nixpkgs/nixos-21.05-small";
    hydra.inputs.nixpkgs.follows = "nixpkgs-hydra";
    hosts-list.url = github:StevenBlack/hosts;
    hosts-list.flake = false;
    nixos-hardware.url = github:NixOS/nixos-hardware;
    miifox-net.url = "git+https://git.chir.rs/CarolineHusky/MiiFox.net";
    miifox-net.flake = false;
  };

  outputs = { self, nixpkgs, sops-nix, home-manager, chir-rs, nur, polymc, ... } @ args:
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
        /*{
          name = "installer"; # The Installer DVD
          system = "x86_64-linux";
          }*/
        #{
        #  name = "rpi2"; # Raspberry Pi 2
        #  system = "armv7l-linux";
        #}
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
                      })
                      nur.overlay
                      polymc.overlay
                    ];
                  })
                  (import utils/link-input.nix args)
                ];
              };
          })
          systems);
      hydraJobs = (builtins.listToAttrs (map
        ({ name, system }: {
          inherit name;
          value = {
            ${system} = nixosConfigurations.${name}.config.system.build.toplevel;
          };
        })
        systems))/* // {
        installer.x86_64-linux = nixosConfigurations.installer.config.system.build.isoImage;
        }*/;
    };
}
