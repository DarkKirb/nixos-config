{pkgs, ...}: {
  output.plugins = with pkgs.vimPlugins; [(nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars))];
  plugin.setup."nvim-treesitter.configs" = {
    highlight.enable = true;
  };
}
