{
  mgba,
  fetchFromGitHub,
}: let
  source = builtins.fromJSON (builtins.readFile ./source.json);
in
  mgba.overrideAttrs (super: {
    version = source.date;
    src = fetchFromGitHub {
      owner = "mgba-emu";
      repo = "mgba";
      inherit (source) rev sha256;
    };

    passthru.updateScript = [../../scripts/update-git.sh "https://github.com/mgba-emu/mgba" "emulator/mgba-dev/source.json"];
  })
