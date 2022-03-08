rec {
  description = "Lotte's NixOS installation";

  # Use NixOS unstable
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs;
    nixpkgs-soundtouch.url = "github:darkkirb/nixpkgs?ref=soundtouch-2.3.1";
    nixpkgs-wxwidgets.url = "github:knl/nixpkgs?ref=wxwidgets-3.1-update";
    flake-utils.url = github:numtide/flake-utils;
    rust-overlay.url = github:oxalica/rust-overlay;
    cargo2nix.url = "github:cargo2nix/cargo2nix/be-friendly-to-users"; # dummy
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = github:Mic92/sops-nix;
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    chir-rs.url = "git+https://git.chir.rs/darkkirb/chir.rs.git?ref=main";
    #chir-rs.inputs.nixpkgs.follows = "nixpkgs"; # nixpkgs regression?
    nur.url = "github:nix-community/NUR";
    nix-gaming.url = github:fufexan/nix-gaming;
    #nix-gaming.inputs.nixpkgs.follows = "nixpkgs"; # rebuilds wine-tkg literally every goddamn time
    polymc.url = "github:PolyMC/PolyMC";
    polymc.inputs.nixpkgs.follows = "nixpkgs";
    dns.url = "github:DarkKirb/dns.nix?ref=master";
    dns.inputs.nixpkgs.follows = "nixpkgs";
    rust-binaries.url = "git+https://git.chir.rs/darkkirb/rust-binaries?ref=main";
    rust-binaries.inputs.nixpkgs.follows = "nixpkgs";
    rust-binaries.inputs.flake-utils.follows = "flake-utils";
    rust-binaries.inputs.rust-overlay.follows = "rust-overlay";
    rust-binaries.inputs.cargo2nix.follows = "cargo2nix";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";
    rust-overlay.inputs.flake-utils.follows = "flake-utils";
    cargo2nix.inputs.rust-overlay.follows = "rust-overlay";
    cargo2nix.inputs.nixpkgs.follows = "nixpkgs";
    cargo2nix.inputs.flake-utils.follows = "flake-utils";
  };

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
                        nix-gaming = nix-gaming.outputs.packages.${system};
                        rust-binaries = args.rust-binaries.packages.${system};
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

