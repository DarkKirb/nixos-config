{pkgs, ...}: {
  output.plugins = with pkgs.vimPlugins; [dressing-nvim];
  plugin.setup.dressing = {};
}
