{config, ...}: {
  imports = [
    ./steam
  ];
  home-manager.users.darkkirb.imports =
    if config.isGraphical
    then [
      ./home-manager.nix
    ]
    else [];
}
