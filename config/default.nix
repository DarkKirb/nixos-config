{ pkgs, ... }: {
  imports = [
    ./zfs.nix
  ];
  nix = {
    package = pkgs.nixUnstable; # or versioned attributes like nix_2_4
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
}
