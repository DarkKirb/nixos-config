{
  config,
  lib,
  ...
}:
let
  cfg = config.nix.defaultSettings;
in
{
  imports = [
    ./link-inputs.nix
    ./lix.nix
    ./autoupdater.nix
    ./build-server.nix
  ];
  options.nix.defaultSettings = {
    enable = lib.mkEnableOption "Whether to use the default opinionated nix settings";
    autoOptimizeStore = lib.mkEnableOption "Whether or not to automatically optimize the nix store";
  };
  config = lib.mkMerge [
    {
      nix.defaultSettings.enable = lib.mkDefault (config.nix.enable && config.system.standardConfig);
      nix.defaultSettings.autoOptimizeStore = lib.mkDefault (config.system.rootDiskType == "ssd");
      assertions = [
        {
          assertion = cfg.enable -> config.nix.enable;
          message = "Enabling the opinionated nix settings only makes sense when nix is enabled.";
        }
      ];
    }
    (lib.mkIf config.nix.defaultSettings.enable {
      nix.settings = {
        substituters = lib.mkMerge [
          [ "https://attic.chir.rs/chir-rs/" ]
          (lib.mkIf (!config.system.isInstaller) [ "https://hydra.int.chir.rs" ])
          (lib.mkIf config.system.isInstaller [ "https://hydra.chir.rs" ])
        ];
        trusted-public-keys = [
          "nixcache:8KKuGz95Pk4UJ5W/Ni+pN+v+LDTkMMFV4yrGmAYgkDg="
          "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs="
          "chir-rs:rzK1Czm3RqBbZLnXYrLM6JyOhfr6Z/8lhACIPO/LNFQ="
        ];
        auto-optimise-store = cfg.autoOptimizeStore;
        experimental-features = "nix-command flakes ca-derivations";
      };
      nix.gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };
    })
    {
      nixpkgs.config.allowUnfree = true;
      nixpkgs.config.permittedInsecurePackages = [
        "olm-3.2.16"
        "openssl-1.1.1w"
      ];
    }
  ];
}
