{ lib, systemConfig, ... }:
{
  imports = [
    (
      if !systemConfig.isSway then
        {
          programs.plasma.configFile.kwinrc.Wayland."InputMethod[$e]" =
            "${systemConfig.i18n.inputMethod.package}/share/applications/fcitx5-wayland-launcher.desktop";
        }
      else
        { }
    )
  ];
  xdg.configFile."fcitx5/profile".text = lib.generators.toINI { } {
    "Groups/0" = {
      Name = "Default";
      "Default Layout" = "de-neo";
      DefaultIM = "anthy";
    };
    "Groups/0/Items/0" = {
      Name = "keyboard-de-neo";
      Layout = "";
    };
    "Groups/0/Items/1" = {
      Name = "anthy";
      Layout = "";
    };
    GroupOrder = {
      "0" = "default";
    };
  };
  home.activation.nuke-fcitx5-profile = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    run rm -f $VERBOSE_ARG $HOME/.config/fcitx5/profile
  '';
}
