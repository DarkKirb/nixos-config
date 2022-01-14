{ pkgs, ... }: {
  imports = [
    ./zfs.nix
    ./users/darkkirb.nix
  ];
  nix = {
    package = pkgs.nixUnstable; # or versioned attributes like nix_2_4
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  services.openssh.enable = true;
  environment.systemPackages = [ pkgs.git ];
}
