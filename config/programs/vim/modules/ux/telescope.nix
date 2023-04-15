{pkgs, ...}: {
  output.plugins = with pkgs.vimPlugins; [telescope-nvim telescope-nvim];
}
