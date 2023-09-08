{
  pkgs,
  config,
  ...
}: {
  output.plugins =
    if config.isDesktop
    then with pkgs.vimPlugins; [vimtex]
    else [];
}
