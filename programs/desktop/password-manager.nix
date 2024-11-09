{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    keepassxc
  ];
  xdg.configFile."keepassxc.ini".text = lib.generators.toINI { } {
    General.ConfigVersion = 2;
    Browser = {
      CustomProxyLocation = "";
      Enabled = true;
      UpdateBinaryPath = false;
    };
  };
}
