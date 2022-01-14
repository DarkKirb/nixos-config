{ pkgs, ... }: {
  imports = [
    ./zfs.nix
    ./users/darkkirb.nix
    ./nix.nix
  ];
  services.openssh.enable = true;
  environment.systemPackages = [ pkgs.git ];
  networking.firewall.allowedTCPPorts = [ 22 ];
}
