_: {
  imports = [
    ./shell
    ./editors
  ];
  home-manager.users.root.imports = [
    ./home-manager.nix
  ];
}
