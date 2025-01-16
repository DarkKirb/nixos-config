{ ... }:
{
  services.prometheus.exporters.node = {
    port = 31941;
    enabledCollectors = [
      "buddyinfo"
      "cgroups"
      "systemd"
      "ethtool"
    ];
    enable = true;
  };
}
