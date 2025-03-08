{ pkgs, systemConfig, ... }:
{
  imports =
    [ ./sops.nix ]
    ++ (
      if systemConfig.system.isGraphical then
        [
          ./git.nix
          ./jujutsu.nix
        ]
      else
        [ ]
    );
  home.file.".face.icon".enable = systemConfig.system.isGraphical;
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
