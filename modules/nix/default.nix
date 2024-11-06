{
  config,
  lib,
  ...
}:
with lib; {
  imports = [
    ./link-inputs.nix
    ./lix.nix
    ./autoupdater.nix
    ./build-server.nix
  ];
  nix.settings = {
    substituters = mkMerge [
      ["https://attic.chir.rs/chir-rs/"]
      (mkIf (!config.isInstaller) ["https://hydra.int.chir.rs"])
      (mkIf config.isInstaller ["https://hydra.chir.rs"])
    ];
    trusted-public-keys = [
      "nixcache:8KKuGz95Pk4UJ5W/Ni+pN+v+LDTkMMFV4yrGmAYgkDg="
      "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs="
      "chir-rs:rzK1Czm3RqBbZLnXYrLM6JyOhfr6Z/8lhACIPO/LNFQ="
    ];
    auto-optimise-store = true;
    experimental-features = "nix-command flakes ca-derivations";
  };
  nix.gc = {
    automatic = config.nix.enable;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
}
