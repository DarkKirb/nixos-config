{ pkgs, ... }:
{
  imports = [
    ./git.nix
    ./sops.nix
  ];
  home.file.".face.icon".source =
    let
      pfp = pkgs.stdenvNoCC.mkDerivation {
        pname = "face";
        inherit (pkgs.art-lotte) version;
        src = "${pkgs.art-lotte}/2023-10-26-sammythetanuki-babylottepfp-therian.jxl";
        dontUnpack = true;
        nativeBuildInputs = [ pkgs.libjxl ];
        buildPhase = ''
          djxl $src face.png
        '';
        installPhase = ''
          cp face.png $out
        '';
      };
    in
    "${pfp}";
}
