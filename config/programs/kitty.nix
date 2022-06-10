{ ... }: {
  programs.kitty = {
    enable = true;
    font.name = "FiraCode Nerd Font Mono";
    disable_ligatures = "cursor";
    shell_integration = "disabled";
  };
}
