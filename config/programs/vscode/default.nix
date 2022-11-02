{
  pkgs,
  lib,
  ...
}: {
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = true;
    extensions = with pkgs.vscode-extensions;
      [
        rust-lang.rust-analyzer
        xaver.clang-format
        github.vscode-pull-request-github
      ]
      ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace (import ./extensions.nix).extensions;
    userSettings = {
      "diffEditor.codeLens" = true;
      "editor.bracketPairColorization.enabled" = true;
      "editor.cursorSmoothCaretAnimation" = true;
      "editor.cursorSurroundingLines" = 3;
      "editor.foldingImportsByDefault" = true;
      "editor.fontFamily" = "'FiraCode Nerd Font Mono', 'Noto Sans Mono CJK', monospace";
      "editor.fontLigatures" = true;
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
      "clang-tidy.executable" = "${pkgs.llvmPackages_latest.clang-unwrapped}/bin/clang-tidy";
      "cmake.cmakePath" = "${pkgs.cmake}/bin/cmake";
      "github.copilot.enable" = {"*" = true;};
      "crates.listPreReleases" = true;
      "css.format.spaceAroundSelectorSeparator" = true;
      "less.format.spaceAroundSelectorSeparator" = true;
      "scss.format.spaceAroundSelectorSeparator" = true;
      "vscode-dhall-lsp-server.executable" = "${pkgs.dhall-lsp-server}/bin/dhall-lsp-server";
      "doxdocgen.generic.useGitUserEmail" = true;
      "doxdocgen.generic.useGitUserName" = true;
      "git.confirmSync" = false;
      "clangd.path" = "${pkgs.llvmPackages_latest.clang-unwrapped}/bin/clangd";
      "verilog.ctags.path" = "${pkgs.ctags}/bin/ctags";
      "verilog.languageServer" = "${pkgs.svls}/bin/svls";
      "verilog.linting.linter" = "${pkgs.verilator}/bin/verilator";
      "redhat.telemetry.enabled" = false; # FUCK OFF
      "projectManager.git.baseFolders" = ["/home/darkkirb/sources"];
    };
  };
  home.activation.vscode-server = lib.hm.dag.entryAfter ["write-boundary"] ''
    if test -f ~/.vscode-server; then
      if test -f "~/.vscode/extensions"; then
        if ! test -L "~/.vscode-server/extensions"; then
          $DRY_RUN_CMD ln -s $VERBOSE_ARG ~/.vscode/extensions ~/.vscode-server/
        fi
      fi
      if test -f "~/vscode-server/bin"; then
        for f in ~/.vscode-server/bin/*/node; do
          if ! test -L $f; then
            $DRY_RUN_CMD ln -sf $VERBOSE_ARG ${pkgs.nodejs}/bin/node $f
          fi
        done
      fi
    fi
  '';
}
