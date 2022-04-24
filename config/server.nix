# Configuration unique to servers
{ ... }: {
  imports = [
    ./services/nginx.nix
    ./services/acme.nix
    ./services/fail2ban.nix
    ./services/initrd-ssh.nix
  ];
}
