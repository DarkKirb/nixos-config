{pkgs, ...}: {
  programs.rofi = {
    enable = true;
    font = "Noto Sans";
    extraConfig = {
      display-drun = "   Apps ";
      display-run = "   Run ";
    };
    terminal = "${pkgs.kitty}/bin/kitty";
  };
}
