{
  buildGoApplication,
  fetchFromGitHub,
  go_1_24,
  fetchpatch,
}:
let
  source = builtins.fromJSON (builtins.readFile ./source.json);
in
buildGoApplication {
  pname = "anubis";
  go = go_1_24;
  version = source.date;
  patches = [
    (fetchpatch {
      url = "https://github.com/TecharoHQ/anubis/commit/25d19c38156ff8aa7a01900b5cc5f9c6e1529df9.patch";
      hash = "sha256-KGnpfifw8YVM6Ctha1eIU2512F+++7WNh0PLh27Xl7g=";
    })
  ];
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
