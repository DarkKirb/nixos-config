{
  pkgs,
  config,
  lib,
  ...
}: {
  output.plugins = with pkgs.vimPlugins;
    [
      nvim-cmp
      cmp-cmdline
      cmp-path
      cmp-buffer
      cmp_luasnip
      cmp-git
    ]
    ++ (
      if config.isDesktop
      then [cmp-nvim-lsp]
      else []
    );
  extraLuaModules = ["config.cmp"];
}
