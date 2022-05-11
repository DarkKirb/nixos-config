{ pkgs, ... }: {
  home.packages = with pkgs; [
    discord
    (element-desktop.override {
      useKeytar = false;
    })
  ];
}
