{
  pkgs,
  config,
  ...
}: {
  output.plugins = with pkgs.vimPlugins; [whitespace-nvim];
}
