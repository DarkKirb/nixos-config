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
    matchBlocks."*" =
      lib.hm.dag.entryAfter
        [
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
          bind.address = "/run/user/1000/gnupg/d.gbpmeth5aucqrmhhx93taymi/S.gpg-agent";
          host.address = "/run/user/1000/gnupg/d.gbpmeth5aucqrmhhx93taymi/S.gpg-agent.extra";
        }
        {
          bind.address = "/%d/.local/state/waypipe/server.sock";
          host.address = "/%d/.local/state/waypipe/client.sock";
        }
      ];
      forwardX11 = systemConfig.system.isGraphical;
      forwardX11Trusted = systemConfig.system.isGraphical;
      setEnv.WAYLAND_DISPLAY = "wayland-waypipe";
      extraOptions.StreamLocalBindUnlink = "yes";
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
