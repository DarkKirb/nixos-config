{
  config,
  lib,
  ...
}:
with lib; {
  config = mkIf (!config.isInstaller) {
    services.tailscale = {
      enable = true;
      authKeyFile = config.sops.secrets."services/tailscale/authKey".path;
    };
    sops.secrets."services/tailscale/authKey".sopsFile = ./tailscale.yaml;
    environment.persistence."/persistent".directories = [
      "/var/lib/tailscale"
    ];
  };
}
