_: {
  imports = [
    ./shell
  ];
  programs.eza.enable = true;
  programs.bat.enable = true;
  programs.fzf.enable = true;
  home.shellAliases = {
    cat = "bat";
    less = "bat";
  };
}
