{ pkgs, ... }:

let scheme = "gruvbox";
in {
  output.config_file = "colo ${scheme}";
  vim.g.lightline.colorscheme = scheme;

  vim.g.tokyonight_style = "storm";

  output.plugins = with pkgs.vimPlugins; [ gruvbox tokyonight-nvim ];
}
