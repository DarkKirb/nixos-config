{config, ...}: {
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "build-nas" = {
        hostname = "nas.int.chir.rs";
        identitiesOnly = true;
        identityFile = config.sops.secrets.".ssh/builder_id_ed25519".path;
        port = 22;
        user = "remote-build";
      };
      "build-rainbow-resort" = {
        hostname = "rainbow-resort.int.chir.rs";
        identitiesOnly = true;
        identityFile = config.sops.secrets.".ssh/builder_id_ed25519".path;
        port = 22;
        user = "remote-build";
      };
      "build-aarch64" = {
        hostname = "instance-20221213-1915.int.chir.rs";
        identitiesOnly = true;
        identityFile = config.sops.secrets.".ssh/builder_id_ed25519".path;
        port = 22;
        user = "remote-build";
      };
      "build-riscv" = {
        hostname = "not522.tailbab65.ts.net";
        identitiesOnly = true;
        identityFile = config.sops.secrets.".ssh/builder_id_ed25519".path;
        port = 22;
        user = "remote-build";
      };
    };
  };
  sops.secrets.".ssh/builder_id_ed25519" = {
    mode = "600";
    sopsFile = ./shared-keys.yaml;
  };
}
