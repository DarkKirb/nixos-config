{ ... }: {
  programs.ssh = {
    enable = true;
    "build-nas" = {
      hostname = "backup.int.chir.rs";
      identitiesOnly = true;
      identityFile = "~/.ssh/id_ed25519";
      port = 22;
      user = "darkkirb";
    };
    "build-pc" = {
      hostname = "nutty-noon.int.chir.rs";
      identitiesOnly = true;
      identityFile = "~/.ssh/id_ed25519";
      port = 22;
      user = "darkkirb";
    };
  };
}
