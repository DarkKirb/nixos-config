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
  CURRENT_COMMIT=$(${lib.getExe curl} https://api.github.com/repos/${owner}/${repo}/commits | ${lib.getExe jq} -r '.[0].sha')
  KNOWN_COMMIT=${srcInfo.rev}
  if [ $CURRENT_COMMIT != $KNOWN_COMMIT ]; then
    echo "${name}: Updating from $KNOWN_COMMIT to $CURRENT_COMMIT"
    ${lib.getExe' nix-prefetch-git "nix-prefetch-git"} https://github.com/${owner}/${repo} | ${lib.getExe jq} > ${sourceFileName}
  fi
  echo "${name}: Done"
''
