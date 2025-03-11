{ github-updater, go-updater }:
github-updater {
  name = "mautrix-whatsapp";
  owner = "mautrix";
  repo = "whatsapp";
  source = ./source.json;
  sourceFileName = "packages/matrix/mautrix-whatsapp/source.json";
  afterUpdate = go-updater {
    sourcePath = "$NEW_PATH";
    targetDir = "packages/matrix/mautrix-whatsapp";
  };
}
