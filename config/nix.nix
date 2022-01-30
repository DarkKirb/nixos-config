{ pkgs, lib, ... }: {
  imports = [
    ./workarounds
  ];
  nixpkgs.config.allowUnfree = true;
  nix = {
    package = pkgs.nixUnstable;
    useSandbox = true;
    autoOptimiseStore = true;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    trustedUsers = [ "@wheel" ];
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
    requireSignedBinaryCaches = false; # internal binary cache is unsigned
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
