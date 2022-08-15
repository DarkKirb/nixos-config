{pkgs, ...}: {
  output.plugins = with pkgs.vimPlugins; [
    luasnip
  ];
  output.extraConfig = ''
    lua require('luasnip-config')
    require("luasnip.loaders.from_vscode").lazy_load()
    require("luasnip.loaders.from_vscode").lazy_load({ paths = '${./snippets}' })
  '';
}
