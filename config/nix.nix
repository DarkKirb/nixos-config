{
  pkgs,
  lib,
  config,
  system,
  attic,
  ...
}: let
  attic-client =
    if system == "aarch64-linux"
    then attic.packages.${system}.attic-client
    else pkgs.attic-client;
  post-build-hook = pkgs.writeScript "post-build-hook" ''
    #!${pkgs.bash}/bin/bash
    set -euf
    export IFS=' '
    until ${attic-client}/bin/attic push chir-rs $OUT_PATHS; do
        sleep 5
        echo "Retrying..."
    done
  '';
in {
  imports = [
    ./workarounds
  ];
  sops.secrets."attic/config.toml" = {
    sopsFile = ../secrets/shared.yaml;
    owner = "root";
    key = "attic/config.toml";
    path = "/root/.config/attic/config.toml";
  };
  nixpkgs.config.allowUnfree = true;
  nix = {
    settings = {
      sandbox = true;
      trusted-users = ["@wheel" "remote-build"];
      require-sigs = true;
      builders-use-substitutes = true;
      substituters = [
        "https://attic.chir.rs/chir-rs/"
        "https://hydra.int.chir.rs"
      ];
      trusted-public-keys = [
        "nixcache:8KKuGz95Pk4UJ5W/Ni+pN+v+LDTkMMFV4yrGmAYgkDg="
        "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs="
        "chir-rs:AnwyFacopHSkprD6aXY4/R3J9JYzTbV2rosJCBPaB28="
        "riscv:TZX1ReuoIGt7QiSQups+92ym8nKJUSV0O2NkS4HAqH8="
        "cache.ztier.link-1:3P5j2ZB9dNgFFFVkCQWT3mh0E+S3rIWtZvoql64UaXM="
      ];
      post-build-hook = "${post-build-hook}";
      auto-optimise-store = true;
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
    buildMachines = with lib;
      mkMerge [
        (mkIf (config.networking.hostName != "nas") [
          {
            hostName = "build-nas";
            systems = [
              "armv7l-linux"
              "powerpc-linux"
              "powerpc64-linux"
              "powerpc64le-linux"
              "wasm32-wasi"
              "x86_64-linux"
              "i686-linux"
            ];
            maxJobs = 12;
            speedFactor = 1;
            supportedFeatures = ["kvm" "nixos-test" "big-parallel" "benchmark" "gccarch-znver1" "gccarch-skylake" "ca-derivations"];
          }
        ])
        (mkIf (config.networking.hostName != "nutty-noon") [
          {
            hostName = "build-pc";
            systems = [
              "armv7l-linux"
              "powerpc-linux"
              "powerpc64-linux"
              "powerpc64le-linux"
              "wasm32-wasi"
              "x86_64-linux"
              "i686-linux"
            ];
            maxJobs = 16;
            speedFactor = 2;
            supportedFeatures = ["kvm" "nixos-test" "big-parallel" "benchmark" "gccarch-znver2" "gccarch-znver1" "gccarch-skylake" "ca-derivations"];
          }
        ])
        (mkIf (config.networking.hostName != "instance-20221213-1915") [
          {
            hostName = "build-aarch64";
            systems = [
              "aarch64-linux"
            ];
            maxJobs = 4;
            speedFactor = 1;
            supportedFeatures = ["nixos-test" "benchmark" "ca-derivations" "gccarch-armv8-a" "gccarch-armv8.1-a" "gccarch-armv8.2-a" "big-parallel"];
          }
        ])
        (mkIf (config.networking.hostName != "vf2") [
          {
            hostName = "build-riscv64";
            systems = [
              "riscv32-linux"
              "riscv64-linux"
            ];
            maxJobs = 4;
            speedFactor = 1;
            supportedFeatures = [
              "nixos-test"
              "benchmark"
              "gccarch-rv64gc_zba_zbb"
              "gccarch-rv64gc_zba"
              "gccarch-rv64gc_zbb"
              "gccarch-rv64gc"
              "gccarch-rv32gc_zba_zbb"
              "gccarch-rv32gc_zba"
              "gccarch-rv32gc_zbb"
              "gccarch-rv32gc"
              "ca-derivations"
            ];
          }
        ])
      ];
    distributedBuilds = true;
  };
  system.autoUpgrade = {
    enable = true;
    flake = "git+https://git.chir.rs/darkkirb/nixos-config?ref=main";
    flags = [
      "--no-write-lock-file"
      "-L" # print build logs
    ];
    dates = "hourly";
    randomizedDelaySec = "1h";
  };
  systemd.services.nix-daemon.environment.TMPDIR = "/build";
}
