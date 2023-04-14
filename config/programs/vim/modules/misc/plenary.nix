{pkgs, ...}: {
  output.plugins = with pkgs.vimPlugins; [plenary-nvim];
}
