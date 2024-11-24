{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    keepassxc
  ];
  xdg.configFile."keepassxc/keepassxc.ini".text = lib.generators.toINI { } {
    General.ConfigVersion = 2;
    Browser = {
      CustomProxyLocation = "";
      Enabled = true;
      UpdateBinaryPath = false;
    };
    GUI.ApplicationTheme = "classic";
    FdeSecrets.Enabled = true;
  };
}
