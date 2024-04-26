{
  fetchFromGitHub,
  cmake,
  ninja,
  stdenv,
}: let
  source = builtins.fromJSON (builtins.readFile ./source.json);
in
  stdenv.mkDerivation {
    pname = "asar";
    version = source.date;
    src = fetchFromGitHub {
      owner = "RPGHacker";
      repo = "asar";
      inherit (source) rev sha256;
    };
    nativeBuildInputs = [cmake ninja];
    postPatch = ''
      substituteInPlace src/asar/lib/libasar.pc.in --replace 'ASAR_PKGCONF_INCLUDEDIR' 'CMAKE_INSTALL_FULL_INCLUDEDIR' --replace 'ASAR_PKGCONF_LIBDIR' 'CMAKE_INSTALL_FULL_LIBBDIR'
    '';
    cmakeDir = "../src";
    passthru.updateScript = [../../scripts/update-git.sh "https://github.com/RPGHacker/asar" "compiler/asar/source.json"];
  }
