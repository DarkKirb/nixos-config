{ config, ... }:
{
  imports = [
    ./nvim
  ];
  home-manager.users.darkkirb.imports = if config.system.isGraphical then [ ./vscode ] else [ ];
}
