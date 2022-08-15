{pkgs, ...}: {
  output.plugins = with pkgs.vimPlugins; [
    nvim-cmp

    # Various sources
    cmp_luasnip
    cmp-buffer
    cmp-calc
    cmp-spell
    cmp-path

    cmp-nvim-lua
    cmp-nvim-lsp
    cmp-latex-symbols
  ];

  output.extraConfig = "lua require('cmp-config')";

  plugin.setup.cmp = {
    # TODO: maybe do non-default keybindings?
    # See :help cmp-mapping

    sources = [
      {name = "path";}
      {name = "calc";}
      {name = "nvim_lsp";}
      {name = "nvim_lua";}
      {name = "latex_symbols";}
      {name = "buffer";}
    ];
  };
}
