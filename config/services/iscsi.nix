{ config, ... }: {
  services.openiscsi = {
    name = "iqn.2022-06.rs.chir:${config.networking.hostId}";
    enable = true;
  };
  networking.firewall.interfaces."br0".allowedTCPPorts = [860 3260];
}
