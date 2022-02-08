{ pkgs, lib, ... }: {
  imports = [
    ./workarounds
  ];
  nixpkgs.config.allowUnfree = true;
  nix = {
    settings = {
      sandbox = true;
      trusted-users = [ "@wheel" ];
      require-sigs = false;
      auto-optimise-store = true;
      builders-use-substitutes = true;
    };
    package = pkgs.nixUnstable;
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
        system = "x86_64-linux";
        maxJobs = 12;
        speedFactor = 1;
        supportedFeatures = [ "big-parallel" ];
      }
    ];
    distributedBuilds = true;
  };
  system.autoUpgrade = {
    enable = true;
    flake = "git+https://git.chir.rs/darkkirb/nixos-config.git?ref=main";
    flags = [
      "--no-write-lock-file"
      "-L" # print build logs
    ];
    dates = "daily";
    randomizedDelaySec = "86400";
  };
  systemd.services.nix-daemon.environment.TMPDIR = "/build";
}
