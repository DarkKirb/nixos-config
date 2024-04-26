{fetchFromGitHub}: let
  source = builtins.fromJSON (builtins.readFile ./source.json);
in
  fetchFromGitHub {
    owner = "kreativekorp";
    repo = "open-relay";
    inherit (source) rev sha256;
  }
