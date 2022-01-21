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
    binaryCaches = [
      "s3://cache.int.chir.rs?scheme=https&endpoint=minio.int.chir.rs"
      "https://cache.nixos.org/"
    ];
    requireSignedBinaryCaches = false; # internal binary cache is unsigned
  };
  system.autoUpgrade = {
    enable = true;
    flake = "git+https://git.chir.rs/darkkirb/nixos-config.git?ref=main";
    flags = [
      "--recreate-lock-file"
      "--no-write-lock-file"
      "-L" # print build logs
      "--impure" # unfortunately...
    ];
    dates = "daily";
  };
}
