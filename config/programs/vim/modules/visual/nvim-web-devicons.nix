{pkgs, ...}: {
  output.plugins = with pkgs.vimPlugins; [nvim-web-devicons];
  plugin.setup.nvim-web-devicons = {};
}
