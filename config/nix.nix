{ pkgs, lib, ... }: {
  imports = [
    ./workarounds
  ];
  nixpkgs.config.allowUnfree = true;
  nix = {
    settings = {
      sandbox = true;
      trusted-users = [ "@wheel" ];
      require-sigs = true;
      auto-optimise-store = true;
      builders-use-substitutes = true;
      substituters = [
        "https://f000.backblazeb2.com/file/cache-chir-rs/"
      ];
      trusted-public-keys = [
        "nixcache:8KKuGz95Pk4UJ5W/Ni+pN+v+LDTkMMFV4yrGmAYgkDg="
        "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs="
      ];
    };
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
    buildMachines = [
      {
        hostName = "build-nas";
        systems = [ "x86_64-linux" ];
        maxJobs = 12;
        speedFactor = 1;
        supportedFeatures = [ "gccarch-znver1" ];
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
        speedFactor = 1;
        supportedFeatures = [ "kvm" "nixos-test" "big-parallel" "benchmark" "gccarch-znver2" ];
      }
    ];
    distributedBuilds = true;
  };
  system.autoUpgrade = {
    enable = true;
    flake = "github:DarkKirb/nixos-config/staging";
    flags = [
      "--no-write-lock-file"
      "-L" # print build logs
    ];
    dates = "hourly";
  };
  systemd.services.nix-daemon.environment.TMPDIR = "/build";
}
