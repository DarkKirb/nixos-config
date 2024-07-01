{fetchFromGitHub}: let
  source = builtins.fromJSON (builtins.readFile ./kernel.json);
in
  fetchFromGitHub {
    owner = "raspberrypi";
    repo = "linux";
    inherit (source) rev sha256;
  }
