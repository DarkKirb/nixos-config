{pkgs, ...}: {
  output.plugins = with pkgs.vimPlugins; [lualine-nvim];
  extraLuaModules = ["config.statusline"];
}
