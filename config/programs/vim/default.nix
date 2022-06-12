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
      nvim-lspconfig
      vim-gitgutter
      nvim-web-devicons
      bufferline-nvim
    ];
  };
  xdg.configFile."nvim/lua/base.lua".source = ./base.lua;
}
