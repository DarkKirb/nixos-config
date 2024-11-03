{config, ...}: {
  programs.fish.enable = true;
  home-manager.users.root = [
    ./home-manager.nix
  ];
}
