{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  output.plugins = with pkgs.vimPlugins; [null-ls-nvim plenary-nvim];

  output.config_file = ''
    lua require("null-ls-config")
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
