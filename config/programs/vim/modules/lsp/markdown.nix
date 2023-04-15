{
  pkgs,
  config,
  ...
}: {
  output.plugins = with pkgs.vimPlugins;
    [
      tabular
      vim-markdown
    ]
    ++ (
      if config.isDesktop
      then
        with pkgs.vimPlugins; [
          markdown-preview-nvim
        ]
      else []
    );
}
