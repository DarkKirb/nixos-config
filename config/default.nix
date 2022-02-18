{ config, pkgs, ... }: {
  imports = [
    ./zfs.nix
    ./users/darkkirb.nix
    ./nix.nix
    ./sops.nix
    ./wireguard.nix
    ./services/loki.nix
    ./home.nix
    ./services/restic.nix
    ./services/nix-cache-upload.nix
  ];
  services.openssh.enable = true;
  environment.systemPackages = with pkgs; [ git pinentry-curses ];
  networking.firewall.allowedTCPPorts = [ 22 ];
  networking.firewall.allowedUDPPortRanges = [
    {
      from = 60000;
      to = 61000;
    }
  ];

  users.defaultUserShell = pkgs.zsh;

  # Prometheus node exporter
  services.prometheus.exporters.node = {
    enable = true;
    enabledCollectors = [
      "interrupts"
      "lnstat"
      "mountstats"
      "network_route"
      "ntp"
      "processes"
      "systemd"
      "tcpstat"
    ];
    listenAddress = (import ../utils/getInternalIP.nix config).listenIP;
  };
  networking.firewall.interfaces."wg0".allowedTCPPorts = [ config.services.prometheus.exporters.node.port ];

  environment.pathsToLink = [ "/share/zsh" ];

  console.keyMap = "neo";

  security.sudo.extraConfig = ''
    Defaults env_keep += "TMUX"
  '';

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "curses";
  };
}
