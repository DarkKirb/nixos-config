{
  vscode-server,
  config,
  systemConfig,
  lib,
  pkgs,
  system,
  ...
}:
if system == "x86_64-linux" then
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
          james-yu.latex-workshop
          jnoortheen.nix-ide
          leonardssh.vscord
          mechatroner.rainbow-csv
          mkhl.direnv
          ms-python.python
          pkief.material-icon-theme
          rust-lang.rust-analyzer
          signageos.signageos-vscode-sops
          tamasfe.even-better-toml
          zhwu95.riscv
        ])
        ++ (with pkgs.vscode-marketplace; [
          ex3ndr.llama-coder
          janisdd.vscode-edit-csv
          jscearcy.rust-doc-viewer
        ]);
      userSettings = {
        "editor.fontLigatures" = true;
        "editor.formatOnPaste" = true;
        "editor.formatOnSave" = true;
        "editor.formatOnType" = true;
        "editor.unicodeHighlight.ambiguousCharacters" = false;
        "inference.endpoint" = "http://rainbow-resort.int.chir.rs:11434";
        "inference.model" = "codellama:7b-code-q4_K_S";
        "inference.custom.format" = "codellama";
        "nix.enableLanguageServer" = true;
        "nix.formatterPath" = "${lib.getExe pkgs.nixfmt-rfc-style}";
        "nix.serverPath" = "${lib.getExe pkgs.nil}";
        "nix.serverSettings" = {
          nil.formatting.command = [ "${lib.getExe pkgs.nixfmt-rfc-style}" ];
        };
        "rust-analyzer.cargo.targetDir" = "${config.xdg.cacheHome}/cargo/rust-analyzer-target";
        "rust-analyzer.check.command" = "clippy";
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
        "sops.binPath" = "${lib.getExe pkgs.sops}";
        "workbench.iconTheme" = "material-icon-theme";
      };
    };
    services.vscode-server.enable = true;
    systemd.user.tmpfiles.rules = lib.mkMerge [
      [
        "d /persistent${config.xdg.cacheHome}/Code/Cache - - - - -"
        "d /persistent${config.xdg.cacheHome}/Code/CachedData - - - - -"
        "d /persistent${config.xdg.cacheHome}/Code/CachedProfilesData - - - - -"
        "d /persistent${config.xdg.cacheHome}/Code/Code\\x20Cache - - - - -"
        "d /persistent${config.xdg.cacheHome}/Code/DawnGraphiteCache - - - - -"
        "d /persistent${config.xdg.dataHome}/Code - - - - -"
        "L /persistent${config.xdg.dataHome}/Code/Cache - - - - ${config.xdg.cacheHome}/Code/Cache"
        "L /persistent${config.xdg.dataHome}/Code/CachedData - - - - ${config.xdg.cacheHome}/Code/CachedData"
        "L /persistent${config.xdg.dataHome}/Code/CachedProfilesData - - - - ${config.xdg.cacheHome}/Code/CachedProfilesData"
        "L /persistent${config.xdg.dataHome}/Code/Code\\x20Cache - - - - ${config.xdg.cacheHome}/Code/Code\\x20Cache"
        "L /persistent${config.xdg.dataHome}/Code/DawnGraphiteCache - - - - ${config.xdg.cacheHome}/Code/DawnGraphiteCache"
        "L ${config.xdg.configHome}/Code - - - - ${config.xdg.dataHome}/Code"
      ]
      # GPU Cache sometimes breaks for electron apps on intel, so only persist that on non-intel
      (lib.mkIf (!systemConfig.isIntelGPU) [
        "d /persistent${config.xdg.cacheHome}/Code/DawnWebGPUCache - - - - -"
        "d /persistent${config.xdg.cacheHome}/Code/GPUCache - - - - -"
        "L /persistent${config.xdg.dataHome}/Code/DawnWebGPUCache - - - - ${config.xdg.cacheHome}/Code/DawnWebGPUCache"
        "L /persistent${config.xdg.dataHome}/Code/GPUCache - - - - ${config.xdg.cacheHome}/Code/GPUCache"
      ])
      (lib.mkIf (systemConfig.isIntelGPU) [
        "d /tmp${config.xdg.cacheHome}/Code/DawnWebGPUCache - - - - -"
        "d /tmp${config.xdg.cacheHome}/Code/GPUCache - - - - -"
        "L /persistent${config.xdg.dataHome}/Code/DawnWebGPUCache - - - - /tmp${config.xdg.cacheHome}/Code/DawnWebGPUCache"
        "L /persistent${config.xdg.dataHome}/Code/GPUCache - - - - /tmp${config.xdg.cacheHome}/Code/GPUCache"
      ])
    ];
    home.persistence.default.directories = [
      ".local/share/Code"
    ];
    home.file.".vscode-server/extensions".source = config.home.file.".vscode/extensions".source;
  }
else
  { }
