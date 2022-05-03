{ pkgs, ... }: {
  systemd.services."prometheus-statsd-exporter" = {
    enable = true;
    wantedBy = [ "multi-user.target" "mastodon-web.service" "mastodon-sidekiq.service" "mastodon-streaming.service" ];
    after = [ "network.target" ];
    serviceConfig = {
      Restart = "always";
      PrivateTmp = true;
      WorkingDirectory = "/tmp";
      DynamicUser = true;
      CapabilityBoundingSet = [ "" ];
      DeviceAllow = [ "" ];
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      NoNewPrivileges = true;
      PrivateDevices = true;
      ProtectClock = true;
      ProtectControlGroups = true;
      ProtectHome = true;
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectSystem = "strict";
      RemoveIPC = true;
      RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
      RestrictNamespaces = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      SystemCallArchitectures = "native";
      UMask = "0077";
      ExeStart = ''
        ${pkgs.prometheus-statsd-exporter}/bin/prometheus-statsd-exporter --web-listen-adress="[::]:9102" --statsd.listen-upd="127.0.0.1:9125"
      '';
    };
  };
  networking.firewall.interfaces."wg0".allowedTCPPorts = [ 9102 ];
}
