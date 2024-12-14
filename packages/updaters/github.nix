{
  nix-prefetch-git,
  curl,
  jq,
  lib,
}:
{
  name,
  owner,
  repo,
  source,
  sourceFileName,
}:
let
  srcInfo = lib.importJSON source;
in
''
  echo "${name}: Checking for updates"
  CURRENT_COMMIT=$(${curl}/bin/curl https://api.github.com/repos/${owner}/${repo}/commits | ${jq}/bin/jq -r '.[0].sha')
  KNOWN_COMMIT=${srcInfo.rev}
  if [ $CURRENT_COMMIT != $KNOWN_COMMIT ]; then
    echo "${name}: Updating from $KNOWN_COMMIT to $CURRENT_COMMIT"
    ${nix-prefetch-git}/bin/nix-prefetch-git https://github.com/${owner}/${repo} | ${jq}/bin/jq > ${sourceFileName}
  fi
  echo "${name}: Done"
''
