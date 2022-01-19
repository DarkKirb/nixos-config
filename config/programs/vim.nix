{ pkgs, ... }: {
  programs.neovim = {
    enable = true;
    coc = {
      enable = true;
    };
    extraConfig = ''
      set tabstop=4
      set shiftwidth=4
      set expandtab
      set nocompatible
      set number relativenumber
      set mouse=a

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
    '';
    plugins = with pkgs.vimPlugins; [
      nerdtree nerdtree-git-plugin vim-devicons
      ctrlp-vim
    ];
  };
}
