{ pkgs, lib, config, ... }:

with lib;

let
  cfg = config.treesitter;
  grammars = pkgs.tree-sitter.builtGrammars;
in {
  options.treesitter.enable = mkEnableOption "tree-sitter";

  config = mkIf cfg.enable {
    plugin.setup."nvim-treesitter.configs" = {
      highlight.enable = true;
    };

    output.plugins = with pkgs.vimPlugins;
      [ (nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars)) ];
  };
}
