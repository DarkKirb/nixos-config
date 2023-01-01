{...}: {
  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        term = "xterm-256color";
        font = "FiraCode Nerd Font:size=6";
        dpi-aware = "yes";
      };
    };
  };
}
