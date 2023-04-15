{
  pkgs,
  config,
  ...
}: {
  output.plugins = with pkgs.vimPlugins; [nvim-gdb];
}
