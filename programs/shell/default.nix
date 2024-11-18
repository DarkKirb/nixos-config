{ ... }:
{
  imports = [
    ./fish
    ./tmux
  ];

  home-manager.users.root.imports = [
    ./home-manager.nix
  ];
  home-manager.users.darkkirb.imports = [
    ./home-manager.nix
  ];
}
