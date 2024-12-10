{ pkgs, lib, ... }:
{
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-anthy
      fcitx5-chinese-addons # Needed for table inputs: https://lotte.chir.rs/kb/linux/input/table/
      fcitx5-table-extra
    ];
  };
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
}
