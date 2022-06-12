{ pkgs, ... }:
let
  dsquotes = "''";
in
{
  programs.neovim = {
    enable = true;
    extraPackages = with pkgs; [
      universal-ctags
      rust-analyzer
    ];
    extraConfig = ''
      lua require("base")
    '';
    plugins = with pkgs.vimPlugins; [
      nerdtree
      nerdtree-git-plugin
      vim-devicons
      ctrlp-vim
      vim-nix
      tagbar
      vim-airline
      copilot-vim
      rust-vim # for proper syntax highlighting
      tabline-nvim
      nvim-lspconfig
      vim-gitgutter
    ];
  };
  xdg.configFile."nvim/lua/base.lua".source = ./base.lua;
}
