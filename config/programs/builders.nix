{config, ...}: {
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "build-nas" = {
        hostname = "nas.int.chir.rs";
        identitiesOnly = true;
        identityFile = "${config.home.homeDirectory}/.ssh/builder_id_ed25519";
        port = 22;
        user = "remote-build";
      };
      "build-rainbow-resort" = {
        hostname = "rainbow-resort.int.chir.rs";
        identitiesOnly = true;
        identityFile = "${config.home.homeDirectory}/.ssh/builder_id_ed25519";
        port = 22;
        user = "remote-build";
      };
      "build-aarch64" = {
        hostname = "instance-20221213-1915.int.chir.rs";
        identitiesOnly = true;
        identityFile = "${config.home.homeDirectory}/.ssh/builder_id_ed25519";
        port = 22;
        user = "remote-build";
      };
      "backup" = {
        hostname = "backup.int.chir.rs";
        identitiesOnly = true;
        identityFile = "${config.home.homeDirectory}/.ssh/builder_id_ed25519";
        port = 22;
        user = "backup";
      };
      "build-riscv" = {
        hostname = "vf2.int.chir.rs";
        identitiesOnly = true;
        identityFile = "${config.home.homeDirectory}/.ssh/builder_id_ed25519";
        port = 22;
        user = "remote-build";
      };
    };
  };
}
