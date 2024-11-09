{ vscode-server, pkgs, ... }:
{
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
      signageos.signageos-vscode-sops
    ];
    userSettings = {
      "editor.fontFamily" = "\"Fira Code\", \"Fira Code Nerd Font Mono\", monospace";
      "editor.fontLigatures" = true;
      "editor.formatOnPaste" = true;
      "editor.formatOnSave" = true;
      "editor.formatOnType" = true;
      "nix.enableLanguageServer" = true;
      "nix.formatterPath" = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
      "nix.serverPath" = "${pkgs.nil}/bin/nil";
      "nix.serverSettings" = {
        nil.formatting.command = [ "${pkgs.nixfmt-rfc-style}/bin/nixfmt" ];
      };
      "sops.binPath" = "${pkgs.sops}/bin/sops";
      "workbench.iconTheme" = "material-icon-theme";
    };
  };
  services.vscode-server.enable = true;
}
