{...}: {
  imports = [
    ./home-manager.nix
    ./root
  ];
  users.mutableUsers = false;
}
