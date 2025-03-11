{
  buildGoApplication,
  olm,
  fetchFromGitHub,
  go_1_24,
}:
let
  source = builtins.fromJSON (builtins.readFile ./source.json);
in
buildGoApplication {
  pname = "mautrix-whatsapp";
  go = go_1_24;
  version = source.date;
  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "whatsapp";
    inherit (source) rev sha256;
  };
  modules = ./gomod2nix.toml;
  buildInputs = [
    olm
  ];
  CGO_ENABLED = "1";
  meta = {
    description = "whatsapp-Matrix double-puppeting bridge";
  };
}
