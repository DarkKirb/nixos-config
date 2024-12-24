{ ... }:
{
  imports = [
    ./openssh.nix
    ./postgresql
    ./restic.nix
    ./tailscale.nix
    ./desktop/avahi.nix
  ];
}
