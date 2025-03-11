{ github-updater, go-updater }:
github-updater {
  name = "mautrix-slack";
  owner = "mautrix";
  repo = "slack";
  source = ./source.json;
  sourceFileName = "packages/matrix/mautrix-slack/source.json";
  afterUpdate = go-updater {
    sourcePath = "$NEW_PATH";
    targetDir = "packages/matrix/mautrix-slack";
  };
}
