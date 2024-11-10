{
  nix-prefetch-git,
  curl,
  jq,
}:
''
  echo "lotte-art: Checking for updates"
  set CURRENT_COMMIT $(${curl}/bin/curl https://git.chir.rs/api/v1/repos/darkkirb/lotte-art/commits | ${jq}/bin/jq -r '.[0].sha')
  set KNOWN_COMMIT $(${jq}/bin/jq -r '.rev' packages/art/lotte/source.json)
  if [ $CURRENT_COMMIT != $KNOWN_COMMIT ];
    echo "lotte-art: Updating from $KNOWN_COMMIT to $CURRENT_COMMIT"
    ${nix-prefetch-git}/bin/nix-prefetch-git https://git.chir.rs/darkkirb/lotte-art --fetch-lfs | ${jq}/bin/jq > packages/art/lotte/source.json
  end
  echo "lotte-art: Done"
''
