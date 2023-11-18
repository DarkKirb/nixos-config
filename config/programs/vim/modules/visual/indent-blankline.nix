{pkgs, ...}: {
  output.plugins = with pkgs.vimPlugins; [indent-blankline-nvim];
  plugin.setup.ibl = {
    indent.char = "▏";
    indent.highlight = [
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
