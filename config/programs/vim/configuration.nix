# Taken from https://github.com/syberant/nix-config/tree/master/configuration/home-manager/modules/neovim
desktop: {
  pkgs,
  lib,
  config,
  ...
}:
with lib;
with builtins; let
  getNixFiles = dir: let
    recu = n: k:
      if k == "directory"
      then getNixFiles "${dir}/${n}"
      else if hasSuffix "nix" n
      then ["${dir}/${n}"]
      else [];
  in
    flatten (mapAttrsToList recu (readDir dir));
in {
  imports =
    getNixFiles ./modules
    ++ (
      if desktop
      then [./desktop.nix]
      else []
    );

  config = {
    output.path.style = "impure";
    output.makeWrapper = "--set LUA_PATH '${./modules/lua}/?.lua;;'";
    isDesktop = lib.mkDefault false;
    extraLua = builtins.concatStringsSep "\n" (map (f: "require('${f}')") config.extraLuaModules);
    output.extraConfig = ''
      lua << EOF_991fbac8c1efc440
      ${config.extraLua}
      EOF_991fbac8c1efc440
    '';
  };

  options.isDesktop = lib.options.mkEnableOption "desktop integration and LSP";
  options.extraLua = lib.options.mkOption {
    type = lib.types.lines;
    default = "";
    description = "Extra lua configuration to add";
  };
  options.extraLuaModules = lib.options.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [];
    description = "Extra lua modules to require";
  };
}
