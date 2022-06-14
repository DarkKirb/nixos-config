_: {
  programs.kitty = {
    enable = true;
    font.name = "FiraCode Nerd Font Mono";
    settings = {
      disable_ligatures = "cursor";
      shell_integration = "disabled";
    };
    extraConfig = ''
      symbol_map U+F1900-U+F19FF Fairfax HD
      narrow_symbols U+F1900-U+F19FF 2
    '';
  };
}
