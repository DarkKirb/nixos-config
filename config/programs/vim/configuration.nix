{ pkgs, lib, ... }:

with lib;
with builtins;

let
  getNixFiles = dir:
    let
      recu = n: k:
        if k == "directory" then
          getNixFiles "${dir}/${n}"
        else if hasSuffix "nix" n then
          [ "${dir}/${n}" ]
        else
          [ ];
    in flatten (mapAttrsToList recu (readDir dir));
in {
  imports = getNixFiles ./modules;

  treesitter.enable = true;

  vim.opt = {
    wrap = true;
    lbr = true;
    timeoutlen = 400;
  };

  output.path.style = "impure";
  output.makeWrapper = "--set LUA_PATH '${./modules/lua}/?.lua;;'";
  output.path.path = with pkgs; [ xclip ];

  output.extraConfig = ''
    " Keybindings
    :lua require'keybindings'

    " TODO: Set clipboard tool with g:clipboard
  '';
}

# TODO:
# https://idie.ru/posts/vim-modern-cpp
