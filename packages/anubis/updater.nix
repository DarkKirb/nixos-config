{ github-updater, go-updater }:
github-updater {
  name = "anubis";
  owner = "TecharoHQ";
  repo = "anubis";
  source = ./source.json;
  sourceFileName = "packages/anubis/source.json";
  afterUpdate = go-updater {
    sourcePath = "$NEW_PATH";
    targetDir = "packages/anubis";
  };
}
