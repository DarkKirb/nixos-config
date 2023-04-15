{
  pkgs,
  config,
  ...
}: {
  output.plugins = with pkgs.vimPlugins; [
    fidget-nvim
  ];
}
