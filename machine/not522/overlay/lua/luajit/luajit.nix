{
  self,
  callPackage,
  fetchFromGitHub,
  lib,
  passthruFun,
}:
callPackage ./default.nix {
  # The patch version is the timestamp of the git commit,
  # obtain via `cat $(nix-build -A luajit_2_0.src)/.relver`
  version = "2.1.1713773202";

  src = fetchFromGitHub {
    owner = "plctlab";
    repo = "LuaJIT";
    rev = "1893cf72c264f837596614a537a18e83b8c1b678";
    sha256 = "sha256-zgTeMpAzIb05Dv9ey7ER075218MkI+ZmT3nYpNCdS+w=";
  };

  extraMeta = {
    # this isn't precise but it at least stops the useless Hydra build
    platforms = lib.filter (p: !lib.hasPrefix "aarch64-" p) (
      lib.platforms.linux ++ lib.platforms.darwin
    );
  };
  inherit self passthruFun;
}
