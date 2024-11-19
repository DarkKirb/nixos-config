{ ... }:
{
  services.xserver.enable = true;
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    wayland.compositor = "kwin";
  };
  services.desktopManager.plasma6.enable = true;

  imports = [
    ./i18n.nix
  ];

  home-manager.users.darkkirb.imports = [
    ./home-manager.nix
  ];
}
