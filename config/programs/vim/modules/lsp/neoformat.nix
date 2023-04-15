{
  pkgs,
  config,
  ...
}: {
  output.plugins =
    if config.isDesktop
    then with pkgs.vimPlugins; [neoformat]
    else [];
  lspconfigPath = with pkgs; [
    clang-tools
    cmake-format
    nodePackages.prettier
    dhall
    elixir
    go
    ormolu
    taplo
    stylua
    alejandra
    yapf
    rustfmt
    shfmt
  ];
}
