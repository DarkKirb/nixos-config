{pkgs, ...}: {
  output.plugins = with pkgs.vimPlugins; [
    nvim-cmp
    cmp-cmdline
    cmp-path
    cmp-buffer
    cmp-nvim-lsp
    cmp_luasnip
    cmp-git
  ];
  extraLuaModules = ["config.cmp"];
}
