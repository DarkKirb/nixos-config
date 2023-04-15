{
  pkgs,
  config,
  ...
}: {
  output.plugins =
    if config.isDesktop
    then with pkgs.vimPlugins; [firenvim]
    else [];
  output.extraConfig =
    if config.isDesktop
    then ''
      silent call firenvim#install(0)
    ''
    else "";
}
