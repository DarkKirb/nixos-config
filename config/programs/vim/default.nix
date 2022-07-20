{pkgs, ...}: let
  dsquotes = "''";
  nvim-jdtls = pkgs.stdenvNoCC.mkDerivation rec {
    name = "nvim-jdtls.lua";
    src = ./nvim-jdtls.lua;
    dontUnpack = true;
    java = pkgs.openjdk;
    jdtLanguageServer = pkgs.jdt-language-server;
    buildInputs = [java jdtLanguageServer];
    buildPhase = ''
      export launcher="$(ls $jdtLanguageServer/share/java/plugins/org.eclipse.equinox.launcher_* | sort -V | tail -n1)"
      substituteAll $src nvim-jdtls.lua
    '';
    installPhase = ''
      cp nvim-jdtls.lua $out
    '';
  };
in {
  programs.neovim = {
    enable = true;
    extraPackages = with pkgs; [
      universal-ctags
      rust-analyzer
      nodejs-16_x
      ripgrep
      gopls
    ];
    extraConfig = ''
      lua require("base")
    '';
    plugins = with pkgs.vimPlugins; [
      {
        plugin = nerdtree;
        config = "lua dofile(\"${./nerdtree.lua}\")";
      }
      {
        plugin = nerdtree-git-plugin;
        config = "lua dofile(\"${./nerdtree-git.lua}\")";
      }
      vim-devicons
      {
        plugin = ctrlp-vim;
        config = "lua dofile(\"${./ctrlp.lua}\")";
      }
      vim-nix
      {
        plugin = tagbar;
        config = "lua dofile(\"${./tagbar.lua}\")";
      }
      {
        plugin = vim-airline;
        config = "lua dofile(\"${./airline.lua}\")";
      }
      copilot-vim
      rust-vim # for proper syntax highlighting
      luasnip
      cmp-nvim-lsp
      cmp_luasnip
      {
        plugin = nvim-cmp;
        config = "lua dofile(\"${./cmp.lua}\")";
      }
      {
        plugin = nvim-lspconfig;
        config = "lua dofile(\"${./lsp.lua}\")";
      }
      vim-gitgutter
      nvim-web-devicons
      {
        plugin = bufferline-nvim;
        config = "lua require(\"bufferline\").setup{}";
      }
      plenary-nvim
      telescope-ui-select-nvim
      {
        plugin = telescope-nvim;
        config = "lua dofile(\"${./telescope.lua}\")";
      }
      {
        plugin = rust-tools-nvim;
        config = "lua dofile(\"${./rust-tools.lua}\")";
      }
      {
        plugin = nvim-jdtls;
        config = "lua dofile(\"${nvim-jdtls}\")";
      }
      nvim-dap
    ];
  };
  xdg.configFile."nvim/lua/base.lua".source = ./base.lua;
}
