{
  fetchFromGitHub,
  stdenv,
  qtbase,
  wrapQtAppsHook,
  pkg-config,
  SDL,
  libXv,
  libao,
  openal,
}: let
  source = builtins.fromJSON (builtins.readFile ./source.json);
in
  stdenv.mkDerivation {
    pname = "bsnes-plus";
    version = source.date;
    src = fetchFromGitHub {
      owner = "devinacker";
      repo = "bsnes-plus";
      inherit (source) rev sha256;
    };
    makeFlags = ["-C" "bsnes" "out=bsnes"];
    buildInputs = [qtbase SDL libXv libao openal];
    nativeBuildInputs = [wrapQtAppsHook pkg-config];
    passthru.updateScript = [../../scripts/update-git.sh "https://github.com/devinacker/bsnes-plus" "emulator/bsnes-plus/source.json"];
    preInstall = ''
      export HOME=$(mktemp -d)
      export prefix=$out
    '';
    preFixup = ''
      qtWrapperArgs+=("--unset" "WAYLAND_DISPLAY")
    '';
    enableParallelBuilding = true;
  }
