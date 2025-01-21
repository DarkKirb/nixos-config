{ fetchFromGitHub }:
let
  source = builtins.fromJSON (builtins.readFile ./devterm.json);
in
fetchFromGitHub {
  owner = "clockworkpi";
  repo = "DevTerm";
  inherit (source) rev sha256;
}
