{
  pkgs,
  nixpkgs,
  lib,
  ...
}: let
  x86_64-linux-pkgs = import nixpkgs {
    system = "x86_64-linux";
    config.allowUnfree = true;
  };
in {
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
  programs.vscode = {
    enable = true;
    enableUpdateCheck = false;
    userSettings = {
      "workbench.iconTheme" = "material-icon-theme";
      "cmake.configureOnOpen" = true;
      "[c]" = {
        "editor.defaultFormatter" = "xaver.clang-format";
      };
      "[cpp]" = {
        "editor.defaultFormatter" = "xaver.clang-format";
      };
      "editor.suggestSelection" = "first";
      "vsintellicode.modify.editor.suggestSelection" = "automaticallyOverrodeDefaultValue";
      "[rust]" = {
        "editor.defaultFormatter" = "statiolake.vscode-rustfmt";
      };
      "git.enableSmartCommit" = true;
      "workbench.editorAssociations" = {
        "*.ipynb" = "jupyter.notebook.ipynb";
      };
      "editor.inlineSuggest.enabled" = true;
      "files.exclude" = {
        "**/.classpath" = true;
        "**/.project" = true;
        "**/.settings" = true;
        "**/.factorypath" = true;
      };
      "latex-workshop.view.pdf.viewer" = "tab";
      "latex-workshop.latex.tools" = [
        {
          "name" = "latexmk";
          "command" = "${pkgs.texlive.combined.scheme-medium}/bin/latexmk";
          "args" = [
            "-synctex=1"
            "-interaction=nonstopmode"
            "-file-line-error"
            "-xelatex"
            "-shell-escape"
            "-outdir=%OUTDIR%"
            "%DOC%"
          ];
          "env" = {};
        }
        {
          "name" = "lualatexmk";
          "command" = "${pkgs.texlive.combined.scheme-medium}/bin/latexmk";
          "args" = [
            "-synctex=1"
            "-interaction=nonstopmode"
            "-file-line-error"
            "-lualatex"
            "-outdir=%OUTDIR%"
            "%DOC%"
          ];
          "env" = {};
        }
        {
          "name" = "latexmk_rconly";
          "command" = "${pkgs.texlive.combined.scheme-medium}/bin/latexmk";
          "args" = ["%DOC%"];
          "env" = {};
        }
        {
          "name" = "pdflatex";
          "command" = "${pkgs.texlive.combined.scheme-medium}/bin/pdflatex";
          "args" = [
            "-synctex=1"
            "-interaction=nonstopmode"
            "-file-line-error"
            "%DOC%"
          ];
          "env" = {};
        }
        {
          "name" = "bibtex";
          "command" = "${pkgs.texlive.combined.scheme-medium}/bin/bibtex";
          "args" = ["%DOCFILE%"];
          "env" = {};
        }
      ];
      "security.workspace.trust.untrustedFiles" = "open";
      "latex-workshop.message.update.show" = false;
      "editor.codeLensFontFamily" = "\"FiraCode Nerd Font Mono\", \"Noto Sans Mono CJK JP\", monospace";
      "editor.fontFamily" = "\"FiraCode Nerd Font Mono\", \"Noto Sans Mono CJK JP\", monospace";
      "rust-analyzer.checkOnSave.command" = "clippy";
      "ledger.binary" = "${pkgs.hledger}/bin/hledger";
      "workbench.colorTheme" = "Catppuccin Mocha";
      "window.titleBarStyle" = "custom";
      "rust-analyzer.hoverActions.references" = true;
      "rust-analyzer.lens.methodReferences" = true;
      "rust-analyzer.workspace.symbol.search.scope" = "workspace_and_dependencies";
      "rust-analyzer.workspace.symbol.search.kind" = "all_symbols";
      "rust-analyzer.lens.references" = true;
      "rust-analyzer.lens.enumVariantReferences" = true;
      "editor.bracketPairColorization.enabled" = true;
      "C_Cpp.experimentalFeatures" = "Enabled";
      "C_Cpp.dimInactiveRegions" = false;
      "git.confirmSync" = false;
      "files.watcherExclude" = {
        "**/.bloop" = true;
        "**/.metals" = true;
        "**/.ammonite" = true;
      };
      "editor.formatOnSave" = true;
      "rust-analyzer.checkOnSave.extraArgs" = [
        "--"
        "-Wabsolute_paths_not_starting_with_crate"
        "-Welided_lifetimes_in_paths"
        "-Wexplicit_outlives_requirements"
        "-Wkeyword_idents"
        "-Wmacro_use_extern_crate"
        "-Wmeta_variable_misuse"
        "-Wmissing_abi"
        "-Wmissing_copy_implementations"
        "-Wmissing_debug_implementations"
        "-Wmissing_docs"
        "-Wnon_ascii_idents"
        "-Wnoop_method_call"
        "-Wpointer_structural_match"
        "-Wsingle_use_lifetimes"
        "-Wtrivial_casts"
        "-Wtrivial_numeric_casts"
        "-Wunreachable_pub"
        "-Wunused_extern_crates"
        "-Wunused_import_braces"
        "-Wunused_lifetimes"
        "-Wunused_qualifications"
        "-Wvariant_size_differences"
        "-Wclippy::pedantic"
        "-Wclippy::nursery"
        "-Wclippy::all"
      ];
      "github.copilot.enable" = {
        "*" = true;
        "yaml" = true;
        "plaintext" = true;
        "markdown" = true;
      };
      "rust-analyzer.cargo.allFeatures" = true;
      "rust-analyzer.cargo.unsetTest" = [];
      "redhat.telemetry.enabled" = false;
      "openapi.approvedHostnames" = ["raw.githubusercontent.com"];
      "liveServer.settings.donotShowInfoMsg" = true;
      "[typescript]" = {
        "editor.defaultFormatter" = "vscode.typescript-language-features";
      };
      "[javascript]" = {
        "editor.defaultFormatter" = "vscode.typescript-language-features";
      };
      "go.toolsManagement.autoUpdate" = true;
      "nix.serverPath" = "${pkgs.rnix-lsp}/bin/rnix-lsp";
      "python.analysis.typeCheckingMode" = "strict";
      "tabnine.experimentalAutoImports" = true;
      "editor.autoClosingBrackets" = "always";
      "editor.autoClosingDelete" = "always";
      "editor.autoClosingOvertype" = "always";
      "editor.autoClosingQuotes" = "always";
      "editor.definitionLinkOpensInPeek" = true;
      "editor.experimental.pasteActions.enabled" = true;
      "editor.foldingImportsByDefault" = true;
      "editor.linkedEditing" = true;
      "editor.renderWhitespace" = "boundary";
      "editor.rulers" = [72 80 100 120];
      "editor.smoothScrolling" = true;
      "editor.stickyTabStops" = true;
      "editor.stickyScroll.enabled" = true;
      "editor.tabCompletion" = "on";
      "editor.unicodeHighlight.ambiguousCharacters" = false;
      "editor.wordWrapColumn" = 120;
      "editor.cursorSmoothCaretAnimation" = "on";
      "editor.cursorSurroundingLines" = 5;
      "editor.find.autoFindInSelection" = "multiline";
      "editor.fontLigatures" = true;
      "editor.formatOnPaste" = true;
      "editor.formatOnType" = true;
      "diffEditor.codeLens" = true;
      "diffEditor.diffAlgorithm" = "experimental";
      "editor.minimap.renderCharacters" = false;
      "editor.suggest.preview" = true;
      "editor.suggest.shareSuggestSelections" = true;
      "files.enableTrash" = false;
      "files.eol" = "\n";
      "files.insertFinalNewline" = true;
      "files.trimFinalNewlines" = true;
      "files.trimTrailingWhitespace" = true;
      "workbench.experimental.editSessions.partialMatches.enabled" = true;
      "workbench.experimental.settingsProfiles.enabled" = true;
      "workbench.list.smoothScrolling" = true;
      "workbench.startupEditor" = "none";
      "workbench.editor.closeOnFileDelete" = true;
      "explorer.excludeGitIgnore" = true;
      "explorer.fileNesting.enabled" = true;
      "explorer.fileNesting.patterns" = {
        "Cargo.toml" = "Cargo.*";
        "flake.nix" = "flake.lock";
        "*.ts" = "\${capture}.js, \${capture}.d.ts";
        "*.js" = "\${capture}.js.map, \${capture}.min.js, \${capture}.d.ts";
        "*.jsx" = "\${capture}.js";
        "*.tsx" = "\${capture}.ts";
        "tsconfig.json" = "tsconfig.*.json";
        "package.json" = "package-lock.json, .npmrc, yarn.lock, .yarnrc";
      };
      "search.quickOpen.includeSymbols" = true;
      "search.smartCase" = true;
      "search.showLineNumbers" = true;
      "search.seedOnFocus" = true;
      "search.seedWithNearestWord" = true;
      "search.useGlobalIgnoreFiles" = true;
      "search.useParentIgnoreFiles" = true;
      "debug.allowBreakpointsEverywhere" = true;
      "debug.autoExpandLazyVariables" = true;
      "testing.alwaysRevealTestOnStateChange" = true;
      "scm.alwaysShowActions" = true;
      "scm.alwaysShowRepositories" = true;
      "telemetry.telemetryLevel" = "off";
      "better-comments.highlightPlainText" = true;
      "C_Cpp.inlayHints.autoDeclarationTypes.enabled" = true;
      "C_Cpp.inlayHints.autoDeclarationTypes.showOnLeft" = true;
      "C_Cpp.inlayHints.parameterNames.enabled" = true;
      "C_Cpp.inlayHints.referenceOperator.enabled" = true;
      "C_Cpp.inlayHints.referenceOperator.showSpace" = true;
      "csharp.inlayHints.parameters.enabled" = true;
      "csharp.inlayHints.parameters.forIndexerParameters" = true;
      "csharp.inlayHints.parameters.forLiteralParameters" = true;
      "csharp.inlayHints.parameters.forObjectCreationParameters" = true;
      "csharp.inlayHints.parameters.forOtherParameters" = true;
      "csharp.inlayHints.parameters.suppressForParametersThatDifferOnlyBySuffix" = true;
      "csharp.inlayHints.parameters.suppressForParametersThatMatchArgumentName" = true;
      "csharp.inlayHints.parameters.suppressForParametersThatMatchMethodIntent" = true;
      "csharp.inlayHints.types.enabled" = true;
      "csharp.inlayHints.types.forImplicitObjectCreation" = true;
      "csharp.inlayHints.types.forImplicitVariableTypes" = true;
      "csharp.inlayHints.types.forLambdaParameterTypes" = true;
      "cSpell.language" = "en,en-GB";
      "conventionalCommits.emojiFormat" = "emoji";
      "conventionalCommits.showEditor" = true;
      "git.allowForcePush" = true;
      "git.autofetch" = "all";
      "git.autofetchPeriod" = 60;
      "github.gitProtocol" = "ssh";
      "gitlens.showWelcomeOnInstall" = false;
      "gitlens.defaultGravatarsStyle" = "monsterid";
      "vsintellicode.features.python.deepLearning" = "enabled";
      "merge-conflict.autoNavigateNextConflict.enabled" = true;
      "projectManager.git.baseFolders" = ["/home/darkkirb/sources"];
      "projectManager.hg.maxDepthRecursion" = 1;
      "rust-analyzer.assist.emitMustUse" = true;
      "rust-analyzer.diagnostics.experimental.enable" = true;
      "rust-analyzer.lens.references.enumVariant.enable" = true;
      "rust-analyzer.lens.references.method.enable" = true;
      "rust-analyzer.lens.references.trait.enable" = true;
      "rust-analyzer.lens.references.adt.enable" = true;
      "editor.accessibilitySupport" = "off";
      "[jsonc]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "nix.formatterPath" = "${pkgs.alejandra}/bin/alejandra";
      "nix.enableLanguageServer" = true;
    };
    extensions = with x86_64-linux-pkgs.vscode-extensions; [
    ];
  };
}
