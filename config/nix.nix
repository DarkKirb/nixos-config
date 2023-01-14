{
  pkgs,
  lib,
  config,
  system,
  ...
}: let
  post-build-hook = pkgs.writeScript "post-build-hook" ''
    #!/bin/sh
    set -euf
    export IFS=' '
    for f in $OUT_PATHS; do
      ${pkgs.nix}/bin/nix store sign --key-file ${config.sops.secrets."services/nix/cache-key".path} $f
      ${pkgs.nix}/bin/nix copy --to 's3://cache-chir-rs?scheme=https&endpoint=s3.us-west-000.backblazeb2.com&secret-key=${config.sops.secrets."services/nix/cache-key".path}&multipart-upload=true&compression=zstd&compression-level=15' $f
    done
  '';
in {
  imports = [
    ./workarounds
  ];
  nixpkgs.config.allowUnfree = true;
  nix = {
    settings = {
      sandbox = true;
      trusted-users = ["@wheel"];
      require-sigs = true;
      builders-use-substitutes = true;
      substituters = [
        "https://cache.chir.rs/"
        "https://hydra.int.chir.rs/"
      ];
      trusted-public-keys = [
        "nixcache:8KKuGz95Pk4UJ5W/Ni+pN+v+LDTkMMFV4yrGmAYgkDg="
        "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs="
      ];
      post-build-hook = "${post-build-hook}";
    };
    package = pkgs.nix;
    extraOptions = ''
      experimental-features = nix-command flakes ca-derivations
    '';
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    buildMachines = [
      {
        hostName = "build-nas";
        systems = [
          "armv7l-linux"
          "aarch64-linux"
          "powerpc-linux"
          "powerpc64-linux"
          "powerpc64le-linux"
          "riscv32-linux"
          "riscv64-linux"
          "wasm32-wasi"
          "x86_64-linux"
          "i686-linux"
        ];
        maxJobs = 12;
        speedFactor = 1;
        supportedFeatures = ["kvm" "nixos-test" "big-parallel" "benchmark" "gccarch-znver1" "gccarch-skylake" "ca-derivations"];
      }
      {
        hostName = "build-pc";
        systems = [
          "armv7l-linux"
          "aarch64-linux"
          "powerpc-linux"
          "powerpc64-linux"
          "powerpc64le-linux"
          "riscv32-linux"
          "riscv64-linux"
          "wasm32-wasi"
          "x86_64-linux"
          "i686-linux"
        ];
        maxJobs = 16;
        speedFactor = 2;
        supportedFeatures = ["kvm" "nixos-test" "big-parallel" "benchmark" "gccarch-znver2" "gccarch-znver1" "gccarch-skylake" "ca-derivations"];
      }
      {
        hostName = "build-aarch64";
        systems = [
          "aarch64-linux"
        ];
        maxJobs = 2;
        speedFactor = 10;
        supportedFeatures = ["nixos-test" "benchmark" "ca-derivations"];
      }
    ];
    distributedBuilds = true;
  };
  system.autoUpgrade = {
    enable = true;
    flake = "github:DarkKirb/nixos-config";
    flags = [
      "--no-write-lock-file"
      "-L" # print build logs
    ];
    dates = "hourly";
  };
  systemd.services.nix-daemon.environment.TMPDIR = "/build";
  sops.secrets."services/nix/cache-key" = {};
}
