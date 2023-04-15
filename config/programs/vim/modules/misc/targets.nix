{
  pkgs,
  config,
  ...
}: {
  output.plugins = with pkgs.vimPlugins; [targets-vim];
}
