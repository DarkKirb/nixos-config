{pkgs, ...}: {
  output.plugins = with pkgs.vimPlugins; [nvim-web-devicons];
  plugins.setup.nvim-web-devicons = {};
}
