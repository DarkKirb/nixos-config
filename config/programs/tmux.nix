{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    clock24 = true;
    prefix = "C-a";
    sensibleOnTop = true;
  };
}
