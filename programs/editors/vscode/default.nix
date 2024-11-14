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
    extensions =
      (with pkgs.vscode-extensions; [
        fill-labs.dependi
        jnoortheen.nix-ide
        mechatroner.rainbow-csv
        mkhl.direnv
        pkief.material-icon-theme
        rust-lang.rust-analyzer
        signageos.signageos-vscode-sops
        tamasfe.even-better-toml
        vadimcn.vscode-lldb
      ])
      ++ (with pkgs.vscode-marketplace; [
        janisdd.vscode-edit-csv
        jscearcy.rust-doc-viewer
      ]);
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
      "rust-analyzer.diagnostics.experimental.enable" = true;
      "rust-analyzer.diagnostics.styleLints.enable" = true;
      "rust-analyzer.hover.actions.references.enable" = true;
      "rust-analyzer.imports.granularity.enforce" = true;
      "rust-analyzer.inlayHints.bindingModeHints.enable" = true;
      "rust-analyzer.inlayHints.closureCaptureHints.enable" = true;
      "rust-analyzer.inlayHints.closureReturnTypeHints.enable" = "always";
      "rust-analyzer.inlayHints.discriminantHints.enable" = "always";
      "rust-analyzer.inlayHints.lifetimeElisionHints.enable" = "always";
      "rust-analyzer.inlayHints.lifetimeElisionHints.useParameterNames" = true;
      "rust-analyzer.inlayHints.rangeExclusiveHints.enable" = true;
      "rust-analyzer.inlayHints.typeHints.hideClosureInitialization" = false;
      "rust-analyzer.interpret.tests" = true;
      "rust-analyzer.lens.references.adt.enable" = true;
      "rust-analyzer.lens.references.enumVariant.enable" = true;
      "rust-analyzer.lens.references.method.enable" = true;
      "rust-analyzer.lens.references.trait.enable" = true;
      "sops.binPath" = "${pkgs.sops}/bin/sops";
      "workbench.iconTheme" = "material-icon-theme";
    };
  };
  services.vscode-server.enable = true;
}
