{pkgs, ...}: {
  home.packages = with pkgs; [
    (element-desktop.override (_: {
      electron = pkgs.electron-bin;
    }))
    twinkle
    telegram-desktop
    discord
  ];
}
