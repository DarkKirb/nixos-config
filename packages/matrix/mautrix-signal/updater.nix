{ github-updater, go-updater }:
github-updater {
  name = "mautrix-signal";
  owner = "mautrix";
  repo = "signal";
  source = ./source.json;
  sourceFileName = "packages/matrix/mautrix-signal/source.json";
  afterUpdate = go-updater {
    sourcePath = "$NEW_PATH";
    targetDir = "packages/matrix/mautrix-signal";
  };
}
