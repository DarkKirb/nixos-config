{ pkgs, ... }:
let
  dsquotes = "''";
in
{
  programs.neovim = {
    enable = true;
    extraConfig = ''
      set tabstop=4
      set shiftwidth=4
      set expandtab
      set nocompatible
      set number relativenumber
      set mouse=a
      set hidden
      set clipboard=unnamedplus " the *correct* default clipboard thank you
      " Give more space for displaying messages.
      set cmdheight=2
      " Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
      " delays and poor user experience.
      set updatetime=300
      " Don't pass messages to |ins-completion-menu|.
      set shortmess+=c
      set signcolumn=number


      " NerdTree config
      " Automatically open NERDTree and move to the previous window
      autocmd VimEnter * NERDTree | wincmd p
      " Close vim when NERDTree is the only window left
      autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
      " Ban replacing NERDTree
      autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
              \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif

      " NerdTree git plugin
      " Use nerdfonts
      let g:NERDTreeGitStatusUseNerdFonts = 1

      " CtrlP config
      let g:ctrlp_map = '<c-p>'
      let g:ctrlp_cmd = 'CtrlP'

      " Tagbar config
      nmap <F8> :TagbarToggle<CR>



      " ctags path
      let g:tagbar_ctags_bin = '${pkgs.universal-ctags}/bin/ctags'

      " use poweernline fonts
      let g:airline_powerline_fonts = 1
      let g:airline_highlighting_cache = 1
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
    ];
    extraPackages = with pkgs; [
      nodejs_latest
    ];
  };
}
