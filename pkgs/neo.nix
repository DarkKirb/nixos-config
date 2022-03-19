inputs:
let
  pkgs = inputs.channels.nixpkgs;
in
{
  packages.neo2-linux-console = pkgs.stdenvNoCC.mkDerivation {
    name = "neo2-linux-console";
    srcs = inputs.neo2;
    buildPhase = "true";
    installPhase = ''
      mkdir -p $out/share/keymaps/i386
      install linux/console/neo.map $out/share/keymaps/i386/
    '';
  };
}
