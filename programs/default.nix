{ ... }:
{
  imports = [
    ./shell
    ./editors
    ./ssh
    ./desktop
    ./stylix
  ];
  home-manager.users.root.imports = [
    ./home-manager.nix
  ];
  home-manager.users.darkkirb.imports = [
    ./home-manager.nix
  ];
}
