{
  buildGoApplication,
  fetchFromGitea,
  lib,
}:
let
  source = lib.importJSON ./source.json;
in
buildGoApplication {
  pname = "clscrobble";
  version = source.date;
  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "punkscience";
    repo = "clscrobble";
    inherit (source) rev sha256;
  };
  modules = ./gomod2nix.toml;
}
