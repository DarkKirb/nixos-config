{pkgs, ...}: {
  output.plugins =
    if pkgs.system != "riscv64-linux"
    then (with pkgs.vimPlugins; [pkgs.vimPlugins.nvim-treesitter.withAllGrammars])
    else [];
  plugin.setup."nvim-treesitter.configs" =
    if pkgs.system != "riscv64-linux"
    then {
      highlight.enable = true;
      highlight.disable = ["bash"];
    }
    else {};
}
