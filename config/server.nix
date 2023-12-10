# Configuration unique to servers
{pkgs, ...}: {
  imports = [
    ./services/caddy
    ./services/acme.nix
  ];
}
