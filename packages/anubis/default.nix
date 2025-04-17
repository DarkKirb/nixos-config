{
  buildGoApplication,
  fetchFromGitHub,
  go_1_24,
  esbuild,
  gzip,
  zstd,
  brotli
}:
let
  source = builtins.fromJSON (builtins.readFile ./source.json);
in
buildGoApplication {
  pname = "anubis";
  go = go_1_24;
  version = source.date;
  src = fetchFromGitHub {
    owner = "TecharoHQ";
    repo = "anubis";
    inherit (source) rev sha256;
  };
  modules = ./gomod2nix.toml;
  CGO_ENABLED = "1";
  DONT_USE_NETWORK = "1";
  nativeBuildInputs = [
    esbuild
    gzip
    zstd
    brotli
  ];
  postPatch = ''
    substituteInPlace go.mod --replace-fail 1.24.2 ${go_1_24.version}
    patchShebangs web/build.sh
  '';
  preBuild = ''
    ./web/build.sh
  '';
  meta = {
    description = "ai crawler protection";
  };
}
