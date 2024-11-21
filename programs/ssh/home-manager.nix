{
  lib,
  config,
  systemConfig,
  ...
}:
{
  imports = [
    ./builders.nix
  ];
  programs.ssh = {
    controlMaster = "auto";
    controlPersist = "10m";
    matchBlocks."*" =
      lib.hm.dag.entryAfter
        [
          "build-nas"
          "build-rainbow-resort"
          "build-aarch64"
          "build-riscv"
          "rainbow-resort.int.chir.rs"
        ]
        {
          identityFile =
            if config.home.username == "root" then
              systemConfig.sops.secrets.".ssh/id_ed25519_sk".path
            else
              config.sops.secrets.".ssh/id_ed25519_sk".path;
        };
    matchBlocks."rainbow-resort.int.chir.rs" = {
      forwardAgent = true;
      remoteForwards = [
        {
          bind.address = "/%d/.local/state/gnupg/S.gpg-agent";
          host.address = "/%d/.local/state/gnupg/S.gpg-agent.extra";
        }
      ];
    };
    enable = true;
  };
  sops.secrets = lib.mkIf (config.home.username != "root") {
    ".ssh/id_ed25519_sk" = {
      mode = "600";
      sopsFile = ./shared-keys.yaml;
    };
  };
}
