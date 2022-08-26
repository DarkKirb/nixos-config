# Configuration unique to servers
{pkgs, ...}: {
  imports = [
    ./services/caddy
    ./services/acme.nix
    ./services/fail2ban.nix
    ./services/initrd-ssh.nix
  ];
  environment.systemPackages = with pkgs; [
    pinentry-curses
  ];
  programs.gnupg.agent.pinentryFlavor = "curses";
}
