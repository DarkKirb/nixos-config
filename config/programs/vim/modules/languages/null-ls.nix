{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  output.plugins = with pkgs.vimPlugins; [null-ls-nvim plenary-nvim];

  output.config_file = ''
    lua << EOF
      local n = require'null-ls'

      local h = require("null-ls.helpers")
      local methods = require("null-ls.methods")
      local FORMATTING = methods.internal.FORMATTING

      n.setup({
        sources = {
          n.builtins.formatting.stylua,
          n.builtins.formatting.rustfmt,
          n.builtins.formatting.nixfmt,
          -- https://github.com/jose-elias-alvarez/null-ls.nvim/issues/640
          n.builtins.formatting.black.with({ args = { "--quiet", "-" }, }),
        },
      })
    EOF
  '';

  output.path.path = with pkgs; [
    # Formatters
    stylua
    nixfmt
    rustfmt
    black

    # Linters
  ];
}
