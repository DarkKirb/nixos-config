{
  lib,
  config,
  ...
}: {
  imports = [
    ./builders.nix
  ];
  programs.ssh = {
    controlMaster = "auto";
    controlPersist = "10m";
    matchBlocks."*" = lib.hm.dag.entryAfter ["build-nas" "build-rainbow-resort" "build-aarch64" "build-riscv"] {
      identityFile = config.sops.secrets.".ssh/id_ed25519_sk".path;
    };
    enable = true;
  };
  sops.secrets.".ssh/id_ed25519_sk" = {
    mode = "600";
    sopsFile = ./shared-keys.yaml;
  };
}
