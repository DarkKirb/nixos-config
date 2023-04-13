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
