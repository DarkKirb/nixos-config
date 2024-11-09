{config, ...}: {
  imports = [
    ./nvim
  ];
  home-manager.users.darkkirb.imports = if config.isGraphical then [./vscode] else [];
}
