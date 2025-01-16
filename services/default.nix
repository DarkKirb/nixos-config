{ ... }:
{
  imports = [
    ./desktop/avahi.nix
    ./openssh.nix
    ./postgresql
    ./promtail.nix
    ./restic.nix
    ./tailscale.nix
  ];
}
