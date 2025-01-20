{
  stdenv,
  fetchurl,
  pngquant,
  lib,
  libarchive,
}: {
  name,
  manifest,
  ...
} @ args: let
  manifestData = (builtins.fromJSON (builtins.readFile manifest)).${name};
  src = fetchurl {
    url = manifestData.src;
    sha256 = manifestData.src_sha256;
  };
  brokenLicenses = {
    "CC BY-NC-SA 4.0" = lib.licenses.cc-by-nc-sa-20;
    "Apache 2.0" = lib.licenses.asl20;
  };
  fixLicense = license: brokenLicenses.${license} or license;
in
  stdenv.mkDerivation ({
      inherit name src;
      nativeBuildInputs = [
        pngquant
        libarchive
      ];
      unpackPhase = ''
        bsdtar -xf $src
      '';
      buildPhase = ''
        for f in *_256.png; do
          f_new=''${f%_256.png}
          mv $f ''${f_new}.png
        done
        find . -type f -name '*.png' -print0 | xargs -0 -n 1 -P $NIX_BUILD_CORES sh -c '${./crushpng.sh} $0 $0.new 50000'
        for f in $(find . -type f -name '*.new'); do
          mv $f ${"$"}{f%.new}
        done
      '';
      installPhase = ''
        mkdir $out
        cp -r *.png $out
      '';
      meta = {
        inherit (manifestData) description homepage;
        license = fixLicense manifestData.license;
      };
    }
    // args)
