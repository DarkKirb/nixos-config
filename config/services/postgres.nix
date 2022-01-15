{ config, lib, ... }: {
  services.postgresql = {
    enable = true;
    enableTCPIP = true;
    authentication = "host  all all fd0d:a262:1fa6:e621::/64 md5";
  };
  services.prometheus.exporters.postgres = {
    enable = true;
    user = "postgres";
    listenAddress = (import ../../utils/getInternalIP.nix config).listenIP;
  };
}
