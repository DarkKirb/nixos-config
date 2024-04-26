{
  fetchFromGitHub,
  python3,
  writeScriptBin,
}: let
  source = builtins.fromJSON (builtins.readFile ./rffmpeg.json);
  python = python3.withPackages (pkgs: with pkgs; [click pyyaml]);
  src = fetchFromGitHub {
    owner = "joshuaboniface";
    repo = "rffmpeg";
    inherit (source) rev sha256;
  };
in
  (writeScriptBin "ffmpeg" "${python}/bin/python ${src}/rffmpeg").overrideAttrs (super: {
    passthru.updateScript = ''
      ${../scripts/update-git.sh} "https://github.com/joshuaboniface/rffmpeg" python/rffmpeg.nix
    '';
  })
