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
      cmp-omni
    ]
    ++ (
      if config.isDesktop
      then [cmp-nvim-lsp cmp-tabnine]
      else []
    );
  extraLuaModules = ["config.cmp"];
}
