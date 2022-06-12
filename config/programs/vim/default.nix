{pkgs, ...}: let
  dsquotes = "''";
in {
  programs.neovim = {
    enable = true;
    extraPackages = with pkgs; [
      universal-ctags
      rust-analyzer
    ];
    extraConfig = ''
      lua require("base")
    '';
    plugins = with pkgs.vimPlugins; [
      {
        plugin = nerdtree;
        config = "lua require(\"${./nerdtree.lua}\")";
      }
      {
        plugin = nerdtree-git-plugin;
        config = "lua require(\"${./nerdtree-git.lua}\")";
      }
      vim-devicons
      {
        plugin = ctrlp-vim;
        config = "lua require(\"${./ctrlp.lua}\")";
      }
      vim-nix
      {
        plugin = tagbar;
        config = "lua require(\"${./tagbar.lua}\")";
      }
      {
        plugin = vim-airline;
        config = "lua require(\"${./airline.lua}\")";
      }
      copilot-vim
      rust-vim # for proper syntax highlighting
      {
        plugin = nvim-lspconfig;
        config = "lua require(\"${./lsp.lua}\")";
      }
      vim-gitgutter
      nvim-web-devicons
      {
        plugin = bufferline-nvim;
        config = "lua require(\"bufferline\").setup{}";
      }
    ];
  };
  xdg.configFile."nvim/lua/base.lua".source = ./base.lua;
}
