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
      lspkind-nvim
    ]
    ++ (
      if config.isDesktop
      then [cmp-nvim-lsp]
      else []
    )
    ++ (
      if config.isDesktop && pkgs.system == "x86_64-linux"
      then [cmp-tabnine]
      else []
    );
  extraLuaModules = ["config.cmp"];
}
