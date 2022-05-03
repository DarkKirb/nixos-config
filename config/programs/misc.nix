{ pkgs, ... }: {
  home.packages = with pkgs; [
    ghidra
    android-studio
    (element-desktop.override {
      useKeytar = false;
    })
  ];
}
