{config, pkgs, ...}: {
  imports = [
    ./steam
  ];
  home-manager.users.darkkirb.imports =
    if config.isGraphical
    then [
      ./home-manager.nix
    ]
    else [];

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    pkgs.elisa
  ];
}
