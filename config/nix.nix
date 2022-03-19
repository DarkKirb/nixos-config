{ pkgs, lib, ... }: {
  imports = [
    ./workarounds
  ];
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.contentAddressedByDefault = true;
  nix = {
    settings = {
      sandbox = true;
      trusted-users = [ "@wheel" ];
      require-sigs = false;
      auto-optimise-store = true;
      builders-use-substitutes = true;
      substituters = [
        "s3://nix-cache?scheme=https&endpoint=cache.int.chir.rs"
      ];
    };
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes ca-derivations
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
        supportedFeatures = [ "gccarch-znver1" "ca-derivations" ];
      }
      #{
      #  hostName = "build-pc";
      #  systems = [ "x86_64-linux" "i686-linux" ];
      #  maxJobs = 16;
      #  speedFactor = 1;
      #  supportedFeatures = [ "big-parallel" "gccarch-znver2" ];
      #}
    ];
    distributedBuilds = true;
  };
  system.autoUpgrade = {
    enable = true;
    flake = "git+https://git.chir.rs/darkkirb/nixos-config.git?ref=staging";
    flags = [
      "--no-write-lock-file"
      "-L" # print build logs
    ];
    dates = "hourly";
    randomizedDelaySec = "3600";
  };
  systemd.services.nix-daemon.environment.TMPDIR = "/build";
}
