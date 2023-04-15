{
  pkgs,
  config,
  ...
}: {
  output.plugins = with pkgs.vimPlugins; [vim-indent-object];
}
