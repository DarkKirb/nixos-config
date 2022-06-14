{pkgs, ...}: {
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-chinese-addons # think this is required for table input?
      fcitx5-table-extra
      fcitx5-table-other
    ];
  };
}
