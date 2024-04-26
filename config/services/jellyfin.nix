{
  config,
  pkgs,
  lib,
  ...
}: let
  rffmpegConfig = pkgs.writeText "rffmpeg-config.yaml" (lib.generators.toYAML {} {
    rffmpeg = {
      directories = {
        state = "/var/lib/jellyfin/rffmpeg";
        persist = "/dev/shm";
        group = "wheel";
      };
      remote = {
        user = "remote-build";
        args = [
          "-i"
          config.sops.secrets."jellyfin/ssh/builder_id_ed25519".path
        ];
      };
      commands = {
        ssh = "${pkgs.openssh}/bin/ssh";
        ffmpeg = "${pkgs.ffmpeg}/bin/ffmpeg";
        ffprobe = "${pkgs.ffmpeg}/bin/ffprobe";
      };
    };
  });
in {
  services.jellyfin.enable = true;
  environment.systemPackages = [
    pkgs.jellyfin
    pkgs.jellyfin-web
    pkgs.jellyfin-ffmpeg
  ];
  services.caddy.virtualHosts."jellyfin.int.chir.rs" = {
    useACMEHost = "int.chir.rs";
    logFormat = pkgs.lib.mkForce "";
    extraConfig = ''
      import baseConfig

      reverse_proxy {
        to http://localhost:8096
        trusted_proxies private_ranges
      }
    '';
  };
  systemd.services.jellyfin = {
    path = lib.mkBefore [pkgs.rffmpeg];
    environment.RFFMPEG_CONFIG = rffmpegConfig;
  };
  sops.secrets."jellyfin/ssh/builder_id_ed25519" = {
    sopsFile = ../../secrets/shared.yaml;
    owner = "jellyfin";
    key = "ssh/builder_id_ed25519";
  };
}
