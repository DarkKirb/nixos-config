# Configuration unique to servers
{pkgs, ...}: {
  imports = [
    ./services/caddy
    ./services/acme.nix
    ./services/fail2ban.nix
  ];

  environment.noXlibs = true;
}
