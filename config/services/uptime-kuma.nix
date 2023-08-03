{
  pkgs,
  lib,
  ...
}: {
  services.uptime-kuma = {
    enable = true;
    settings = {
      PORT = "45566";
    };
  };
  services.caddy.virtualHosts."status.chir.rs" = {
    useACMEHost = "chir.rs";
    logFormat = pkgs.lib.mkForce "";
    extraConfig = ''
      import baseConfig

      reverse_proxy http://127.0.0.1:45566
    '';
  };
  systemd.services.uptime-kuma.serviceConfig = {
    DynamicUser = lib.mkForce false;
    User = "uptime-kuma";
    Group = "uptime-kuma";
  };
  users.users.uptime-kuma = {
    description = "auth.chir.rs";
    home = "/var/empty";
    useDefaultShell = true;
    group = "uptime-kuma";
    isSystemUser = true;
  };
  users.groups.uptime-kuma = {};
}
