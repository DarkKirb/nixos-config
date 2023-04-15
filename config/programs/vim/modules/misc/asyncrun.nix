{
  pkgs,
  config,
  ...
}: {
  output.plugins = with pkgs.vimPlugins; [asyncrun-vim];
}
