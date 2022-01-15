{ config, pkgs, ... }: {
  imports = [
    ./zfs.nix
    ./users/darkkirb.nix
    ./nix.nix
    ./sops.nix
    ./wireguard.nix
  ];
  services.openssh.enable = true;
  environment.systemPackages = [ pkgs.git ];
  networking.firewall.allowedTCPPorts = [ 22 ];

  # Prometheus node exporter
  services.prometheus.exporters.node = {
    enable = true;
    enabledCollectors = [
      "buddyinfo"
      "ethtool"
      "interrupts"
      "ksmd"
      "lnstat"
      "logind"
      "mountstats"
      "network_route"
      "ntp"
      #      "perf"
      "processes"
      "qdisc"
      "systemd"
      "tcpstat"
    ];
    listenAddress = (import ../utils/getInternalIP.nix config).listenIP;
  };
  #  boot.kernel.sysctl."kernel.perf_event_paranoid" = 0; # for the perf exporter
}
