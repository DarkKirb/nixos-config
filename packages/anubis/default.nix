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
  meta = {
    description = "ai crawler protection";
  };
}
