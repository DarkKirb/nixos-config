{ ... }: {
  programs.kitty = {
    enable = true;
    font.name = "FiraCode Nerd Font Mono";
    settings = {
      disable_ligatures = "cursor";
      shell_integration = "disabled";
    }
      };
  }
