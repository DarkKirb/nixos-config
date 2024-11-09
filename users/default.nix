{ ... }:
{
  imports = [
    ./home-manager.nix
    ./root
    ./darkkirb
  ];
  users.mutableUsers = false;
}
