{ pkgs, ... }: {
  home.packages = with pkgs; [
    ghidra
    android-studio
    element-desktop-wayland
  ];
}
