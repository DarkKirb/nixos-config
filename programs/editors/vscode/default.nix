{vscode-server, ...}: {
  imports = [
    "${vscode-server}/modules/vscode-server/home.nix"
  ];
  programs.vscode = {
    enable = true;
    enableExtensionUpdateCheck = false;
    enableUpdateCheck = false;
    mutableExtensionsDir = false;
  };
  services.vscode-server.enable = true;
}
