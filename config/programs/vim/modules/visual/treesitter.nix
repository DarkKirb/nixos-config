{pkgs, ...}: {
  output.plugins = with pkgs.vimPlugins; [pkgs.vimPlugins.nvim-treesitter.withAllGrammars];
  plugin.setup."nvim-treesitter.configs" = {
    highlight.enable = true;
    highlight.disable = ["bash"];
  };
}
