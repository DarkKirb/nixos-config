{ system, ... }:
{
  imports =
    [
      ./shell
      ./editors
      ./ssh
      ./desktop
    ]
    ++ (
      if system != "riscv64-linux" then
        [
          ./stylix
        ]
      else
        [ ]
    );
  home-manager.users.root.imports = [
    ./home-manager.nix
  ];
  home-manager.users.darkkirb.imports = [
    ./home-manager.nix
  ];
}
