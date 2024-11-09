{vscode-server, pkgs, ...}: {
  imports = [
    "${vscode-server}/modules/vscode-server/home.nix"
  ];
  programs.vscode = {
    enable = true;
    enableExtensionUpdateCheck = false;
    enableUpdateCheck = false;
    mutableExtensionsDir = false;
    extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      mkhl.direnv
      pkief.material-icon-theme
    ];
    userSettings = {
      "nix.enableLanguageServer" = true;
      "nix.formatterPath" = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
      "nix.serverPath" = "${pkgs.nil}/bin/nil";
      "workbench.iconTheme" = "material-icon-theme";
    };
  };
  services.vscode-server.enable = true;
}
