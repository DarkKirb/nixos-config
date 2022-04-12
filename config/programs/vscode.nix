{ pkgs, ... }: {
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = false;
    extensions = (with pkgs.vscode-extensions; [
      bbenoist.nix
      dhall.dhall-lang
      dhall.vscode-dhall-lsp-server
      eamodio.gitlens
      github.copilot
      jnoortheen.nix-ide
      matklad.rust-analyzer
      ms-vscode.cpptools
      ms-vscode-remote.remote-ssh
      scala-lang.scala
      serayuzgur.crates
      tamasfe.even-better-toml
      ritwickdey.liveserver
      vadimcn.vscode-lldb
      yzhang.markdown-all-in-one
    ]) ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
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
        version = "2.21.1";
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
      }
      {
        name = "vscode-direnv";
        publisher = "cab404";
        version = "1.0.0";
        sha256 = "sha256-+nLH+T9v6TQCqKZw6HPN/ZevQ65FVm2SAo2V9RecM3Y=";
      }
      {
        name = "veriloghdl";
        publisher = "mshr-h";
        version = "1.5.3";
        sha256 = "sha256-4BXSG/YllhpXa0z7TqytKyqAKLJvSEsOLt1i6gA+WcE=";
      }
      {
        name = "cmake-tools";
        publisher = "ms-vscode";
        version = "1.10.5";
        sha256 = "sha256-T57uCK1rGe3dBnYbK7QhN2NG3NwTEZm0/EY8S1Pyf7I=";
      }
      {
        name = "cmake";
        publisher = "twxs";
        version = "0.0.17";
        sha256 = "sha256-CFiva1AO/oHpszbpd7lLtDzbv1Yi55yQOQPP/kCTH4Y=";
      }
      {
        name = "better-cpp-syntax";
        publisher = "jeff-hykin";
        version = "1.15.3";
        sha256 = "sha256-ugn7nERz/IZ37mD/WWOWHcaB7nMLkeN+cCTCGCUHpOo=";
      }
      {
        name = "cpptools-themes";
        publisher = "ms-vscode";
        version = "1.0.0";
        sha256 = "sha256-E0cLGPpCwqnisgsDt6OGVlrO02mL/vuwe87qn/oCulk=";
      }
      {
        name = "doxdocgen";
        publisher = "cschlosser";
        version = "1.4.0";
        sha256 = "sha256-InEfF1X7AgtsV47h8WWq5DZh6k/wxYhl2r/pLZz9JbU=";
      }
      {
        name = "clang-tidy";
        publisher = "notskm";
        version = "0.5.1";
        sha256 = "sha256-neAvG8bk8yzpbuSzvVVi8Z3lCr29FBncXx3Sv/KChHw=";
      }
    ];
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
      "git.fetchOnPull" = true;
      "git.rebaseWhenSync" = true;
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "${pkgs.rnix-lsp}/bin/rnix-lsp";
      "search.smartCase" = true;
      "telemetry.telemetryLevel" = "off";
      "update.mode" = "none";
      "workbench.colorTheme" = "Monokai";
      "workbench.commandPalette.preserveInput" = true;
      "workbench.iconTheme" = "material-icon-theme";
      "workbench.list.smoothScrolling" = true;
      "C_Cpp.intelliSenseEngine" = "Disabled";
      "C_Cpp.autocomplete" = "Disabled";
      "C_Cpp.errorSquiggles" = "Disabled";
      "clangd.path" = "${pkgs.llvmPackages_latest.clang-unwrapped}/bin/clangd";
    };
  };
}
