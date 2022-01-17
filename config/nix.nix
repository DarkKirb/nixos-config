{ pkgs, ... }: {
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
  };
  system.autoUpgrade = {
    enable = true;
    flake = "git+https://git.chir.rs/darkkirb/nixos-config.git";
    flags = [
      "--recreate-lock-file"
      "--no-write-lock-file"
      "-L" # print build logs
      "--impure" # unfortunately...
    ];
    dates = "daily";
  };
}
