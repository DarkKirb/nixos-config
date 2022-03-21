{ pkgs, ... }: {
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = false;
    extensions = (with pkgs.vscode-extensions; [
      arrterian.nix-env-selector
      bbenoist.nix
      eamodio.gitlens
      github.copilot
      jnoortheen.nix-ide
      matklad.rust-analyzer
      ms-vscode-remote.remote-ssh
      serayuzgur.crates
      tamasfe.even-better-toml
      ritwickdey.liveserver
      vadimcn.vscode-lldb
      yzhang.markdown-all-in-one
    ]) ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [{
      name = "rust-doc-viewer";
      publisher = "jscearcy";
      version = "2.0.1";
      sha256 = "sha256-bVWM3RlcXY0+fACKrOtq63dHo0neyaw/TuhUxwCxeYs=";
    }
    {
      name = "cargo";
      publisher = "panicbit";
      version = "0.2.3";
      sha256 = "sha256-B0oLZE8wtygTaUX9/qOBg9lJAjUUg2i7B2rfSWJerEU=";
    }
    {
      name = "vscode-rust-test-adapter";
      publisher = "swellaby";
      version = "0.11.0";
      sha256 = "sha256-IgfcIRF54JXm9l2vVjf7lFJOVSI0CDgDjQT+Hw6FO4Q=";
    }
    {
      name = "discord-vscode";
      publisher = "icrawl";
      version = "5.8.0";
      sha256 = "sha256-IU/looiu6tluAp8u6MeSNCd7B8SSMZ6CEZ64mMsTNmU=";
    }
    {
      name = "vscode-test-explorer";
      publisher = "hbenl";
      version = "2.21.2";
      sha256 = "sha256-fHyePd8fYPt7zPHBGiVmd8fRx+IM3/cSBCyiI/C0VAg=";
    }
    {
      name = "test-adapter-converter";
      publisher = "ms-vscode";
      version = "0.1.5";
      sha256 = "sha256-nli4WJ96lL3JssNuwLCsthvphI7saFT2ktWQ46VNooc=";
    }
    {
      name = "material-icon-theme";
      publisher = "PKief";
      version = "4.14.1";
      sha256 = "sha256-OHXi0EfeyKMeFiMU5yg0aDoWds4ED0lb+l6T12XZ3LQ=";
    }];
    userSettings = {
      "crates.listPreReleases" = true;
      "diffEditor.codeLens" = true;
      "editor.bracketPairColorization.enabled" = true;
      "editor.cursorSmoothCaretAnimation" = true;
      "editor.cursorSurroundingLines" = 3;
      "editor.foldingImportsByDefault" = true;
      "editor.fontFamily" = "'FiraCode Nerd Font Mono', 'Noto Sans Mono CJK', monospace";
      "editor.formatOnPaste" = true;
      "editor.formatOnSave" = true;
      "editor.formatOnSaveMode" = "modificationsIfAvailable";
      "editor.formatOnType" = true;
      "editor.guides.bracketPairs" = true;
      "editor.inlineSuggest.enabled" = true;
      "editor.renderWhitespace" = "all";
      "editor.smoothScrolling" = true;
      "editor.suggest.localityBonus" = true;
      "editor.suggest.preview" = true;
      "editor.suggest.shareSuggestSelections" = true;
      "editor.tabCompletion" = "on";
      "editor.tabSize" = 2;
      "editor.multiCursorModifier" = "ctrlCmd"; # Multi-Cursor won’t work otherwise
      "explorer.experimental.fileNesting.enabled" = true;
      "files.insertFinalNewline" = true;
      "files.trimFinalNewlines" = true;
      "files.trimTrailingWhitespace" = true;
      "git.autoStash" = true;
      "git.enableCommitSigning" = true;
      "git.enableSmartCommit" = true;
      "git.fetchOnPull"= true;
      "git.rebaseWhenSync" = true;
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "${pkgs.rnix-lsp}/bin/rnix-lsp";
      "search.smartCase" = true;
      "telemetry.telemetryLevel" = "off";
      "terminal.integrated.shellIntegration.enabled" = true;
      "update.mode" = "none";
      "workbench.colorTheme" = "Monokai";
      "workbench.commandPalette.preserveInput" = true;
      "workbench.iconTheme" = "material-icon-theme";
      "workbench.list.smoothScrolling" = true;
    };
  };
}
