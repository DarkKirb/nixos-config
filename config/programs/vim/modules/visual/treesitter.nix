{pkgs, ...}: {
  output.plugins =
    if pkgs.system != "riscv64-linux"
    then with pkgs.vimPlugins; [pkgs.vimPlugins.nvim-treesitter.withAllGrammars]
    else [];
  plugin.setup =
    if pkgs.system != "riscv64-linux"
    then {
      "nvim-treesitter.configs" = {
        highlight.enable = true;
        highlight.disable = ["bash"];
      };
    }
    else {};
}
