{pkgs, ...}: {
  output.plugins = with pkgs.vimPlugins; [indent-blankline-nvim];
  plugin.setup.ibl = {
    show_end_of_line = true;
    char = "▏";
    char_highlight_list = [
      "CatppuccinRosewater"
      "CatppuccinFlamingo"
      "CatppuccinPink"
      "CatppuccinMauve"
      "CatppuccinRed"
      "CatppuccinMaroon"
      "CatppuccinPeach"
      "CatppuccinYellow"
      "CatppuccinGreen"
      "CatppuccinTeal"
      "CatppuccinSky"
      "CatppuccinSapphire"
      "CatppuccinBlue"
      "CatppuccinLavender"
    ];
  };
}
