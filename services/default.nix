{ ... }:
{
  imports = [
    ./openssh.nix
    ./postgresql
    ./restic.nix
    ./tailscale.nix
  ];
}
