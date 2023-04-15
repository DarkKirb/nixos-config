{pkgs, ...}: {
  output.plugins = with pkgs.vimPlugins; [lualine-nvim];
  plugin.setup.lualine.options.theme = "catppuccin";
  extraLuaModules = ["config.statusline"];
}
