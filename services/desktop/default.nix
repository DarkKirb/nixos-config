{ ... }:
{
  imports = [
    ./kdeconnect.nix
    ./gpg
    ./waypipe.nix
    ./nas-mount.nix
    ./ssh.nix
  ];
}
