{
  buildGoApplication,
  fetchFromGitHub,
  go_1_24,
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
  postPatch = ''
    substituteInPlace go.mod --replace-fail 1.24.2 ${go_1_24.version}
  '';
  meta = {
    description = "ai crawler protection";
  };
}
