{
  pkgs,
  lib,
  config,
  ...
}:
{
  home.packages = with pkgs; [
    audacious
    (writeScriptBin "clscrobble" ''
      #!${lib.getExe bash}
      export LISTENBRAINZ_TOKEN=$(cat ${config.sops.secrets."env/LISTENBRAINZ_TOKEN".path})
      exec ${lib.getExe' pkgs.clscrobble "clscrobble"} "$@"
    '')
  ];
  home.persistence.default.directories = [
    ".config/audacious"
  ];
  sops.secrets."env/LISTENBRAINZ_TOKEN".sopsFile = ./listenbrainz.yaml;

}
