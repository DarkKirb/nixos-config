{ ... }:
{
  imports = [
    ./acme
    ./caddy.nix
    ./desktop/avahi.nix
    ./krb5.nix
    ./node-exporter.nix
    ./openssh.nix
    ./postgresql
    ./promtail.nix
    ./restic.nix
    ./tailscale.nix
  ];
}
