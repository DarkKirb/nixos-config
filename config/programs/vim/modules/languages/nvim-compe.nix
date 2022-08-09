{ pkgs, ... }:

{
  output.plugins = with pkgs.vimPlugins; [
    nvim-cmp

    # Various sources
    cmp-path
    cmp-buffer
    cmp-calc
    cmp-nvim-lua
    cmp-nvim-lsp
    cmp-latex-symbols
    cmp-tmux
  ];

  plugin.setup.cmp = {
    # TODO: maybe do non-default keybindings?
    # See :help cmp-mapping

    sources = [
      { name = "path"; }
      { name = "calc"; }
      { name = "nvim_lsp"; }
      { name = "nvim_lua"; }
      { name = "latex_symbols"; }
      { name = "buffer"; }
      {
        name = "tmux";
        option.all_panes = true;
      }
    ];
  };
}
