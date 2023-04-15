{
  pkgs,
  config,
  ...
}: {
  output.plugins = with pkgs.vimPlugins; [vim-sandwich];
}
