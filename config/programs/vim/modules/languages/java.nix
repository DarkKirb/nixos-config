{
  pkgs,
  lib,
  ...
}:
with builtins;
with lib;
let
  jdtls-lua = replaceStrings ["@jdt-language-server@" "@openjdk@"] ["${pkgs.jdt-language-server}" "${pkgs.openjdk}" ] (readFile ../lua/jdtls.lua);
in
{
  output.config_file = ''
    lua << EOF
      ${jdtls-lua}
    EOF
  '';
}
