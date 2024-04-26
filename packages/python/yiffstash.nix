{
  fetchgit,
  python3,
  writeScript,
  curl,
  jq,
}: let
  source = builtins.fromJSON (builtins.readFile ./yiffstash.json);
  python = python3.withPackages (pkgs: with pkgs; [requests]);
  src = fetchgit {
    inherit (source) url rev sha256 fetchLFS;
  };
in
  (writeScript "yiffstash" "cd ${src}; ${python}/bin/python ${src}/tumblrbot.py").overrideAttrs (super: {
    passthru.updateScript = ''
      CURRENT_COMMIT=$(${curl}/bin/curl https://git.chir.rs/api/v1/repos/CarolineHusky/Caroline_Yiffstash_bot/commits | ${jq}/bin/jq -r '.[0].sha')
      KNOWN_COMMIT=${source.rev}
      if [ "$CURRENT_COMMIT"!= "$KNOWN_COMMIT" ]; then
        ${../scripts/update-git.sh} "https://git.chir.rs/CarolineHusky/Caroline_Yiffstash_bot.git" python/yiffstash.json --fetch-lfs
      fi
    '';
  })
