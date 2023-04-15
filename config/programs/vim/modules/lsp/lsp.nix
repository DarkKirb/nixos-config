{
  pkgs,
  lib,
  config,
  ...
}:
with builtins;
with lib; let
  settingsFormat = pkgs.formats.json {};
in {
  config = {
    extraLua = let
      json_setup = settingsFormat.generate "nix-neovim-lsp-server-setup.json" config.lspconfig;
    in
      if config.isDesktop
      then ''
        local from_json = require('nix-neovim.utils').from_json
        for k, v in pairs(from_json("${json_setup}")) do
          require("lspconfig")[k].setup(v)
        end
      ''
      else "";
    output.path.path =
      if config.isDesktop
      then config.lspconfigPath
      else [];
    output.plugins =
      if config.isDesktop
      then [pkgs.vimPlugins.nvim-lspconfig]
      else [];
    vim.keybindings.keybindings =
      if config.isDesktop
      then {
        "<leader>".l = {
          e = {
            command = "<cmd>lua vim.diagnostic.open_float()<cr>";
            label = "Open diagnostic float";
          };
          "[" = {
            command = "<cmd>lua vim.diagnostic.goto_prev()<cr>";
            label = "Prev diagnostic";
          };
          "]" = {
            command = "<cmd>lua vim.diagnostic.goto_next()<cr>";
            label = "Next diagnostic";
          };
          q = {
            command = "<cmd>lua vim.diagnostic.setloclist<cr>";
            label = "Add buffer diagnostics to loc list";
          };
          K = {
            command = "<cmd>lua vim.lsp.buf.hover()<cr>";
            label = "Hover";
          };
          "<C-k>" = {
            command = "<cmd>lua vim.lsp.buf.signature_help()<cr>";
            label = "Signature help";
          };
          w = {
            a = {
              command = "<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>";
              label = "Add workspace folder";
            };
            r = {
              command = "<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>";
              label = "Remove workspace folder";
            };
            l = {
              command = "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>";
              label = "List workspace folders";
            };
          };
          D = {
            command = "<cmd>lua vim.lsp.buf.type_definition()<cr>";
            label = "Show type definition";
          };
          r.n = {
            command = "<cmd>lua vim.lsp.buf.rename()<cr>";
            label = "Rename buffer";
          };
          c.a = {
            command = "<cmd>lua vim.lsp.buf.code_action()<cr>";
            label = "Code action";
          };
          f = {
            command = "<cmd>lua vim.lsp.buf.format({asyync = true})<cr>";
            label = "Format buffer";
          };
        };
        g = {
          D = {
            command = "<cmd>lua vim.lsp.buf.declaration()<cr>";
            label = "Declaration";
          };
          d = {
            command = "<cmd>lua vim.lsp.buf.definition()<cr>";
            label = "Definition";
          };
          i = {
            command = "<cmd>lua vim.lsp.buf.implementation()<cr>";
            label = "Implementation";
          };
          r = {
            command = "<cmd>lua vim.lsp.buf.references()<cr>";
            label = "References";
          };
        };
      }
      else {};
  };

  options.lspconfig = mkOption {
    type = with types; attrsOf (submodule {freeformType = settingsFormat.type;});
    default = {};
    description = ''
      A set of options to `require("lspconfig").KEY.setup(VALUE)` in lua.
    '';
  };

  options.lspconfigPath = mkOption {
    type = with types; listOf package;
    default = [];
    description = "lspconfig binaries.";
  };
}
