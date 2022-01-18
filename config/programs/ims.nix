{ pkgs, ... }: {
  home.packages = with pkgs; [
    discord
    tdesktop
    signal-desktop
  ];
}
