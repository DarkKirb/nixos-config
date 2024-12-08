{ pkgs, ... }:
{
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-anthy
      fcitx5-chinese-addons # Needed for table inputs: https://lotte.chir.rs/kb/linux/input/table/
      fcitx5-table-extra
    ];
  };
}
