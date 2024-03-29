{pkgs, ...}: {
  output.plugins = with pkgs.vimPlugins; [
    luasnip
    vim-snippets
  ];

  extraLua = ''
    require("luasnip.loaders.from_vscode").lazy_load()
    require("luasnip.loaders.from_snipmate").lazy_load()
  '';
}
