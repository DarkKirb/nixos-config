{pkgs, ...}: {
  output.plugins = with pkgs.vimPlugins; [vim-commentary];
}
