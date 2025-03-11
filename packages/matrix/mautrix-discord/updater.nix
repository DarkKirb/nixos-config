{ github-updater, go-updater }:
github-updater {
  name = "mautrix-discord";
  owner = "mautrix";
  repo = "discord";
  source = ./source.json;
  sourceFileName = "packages/matrix/mautrix-discord/source.json";
  afterUpdate = go-updater {
    sourcePath = "$NEW_PATH";
    targetDir = "packages/matrix/mautrix-discord";
  };
}
