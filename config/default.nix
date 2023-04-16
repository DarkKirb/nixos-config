{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./zfs.nix
    ./users/darkkirb.nix
    ./users/root.nix
    ./nix.nix
    ./sops.nix
    ./wireguard
    ./home.nix
    ./services/restic.nix
    ./specialization.nix
    ./services/promtail.nix
    ./env.nix
    ./tailscale.nix
  ];
  services.openssh.enable = true;
  environment.systemPackages = with pkgs; [
    git
    kitty.terminfo
  ];
  networking.firewall.allowedTCPPorts = [22];
  networking.firewall.allowedUDPPortRanges = [
    {
      from = 60000;
      to = 61000;
    }
  ];

  users.defaultUserShell = pkgs.zsh;

  # Enable zram swap in every case
  zramSwap = {
    enable = true;
  };

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
    listenAddress = "0.0.0.0";
  };
  networking.firewall.interfaces."wg0".allowedTCPPorts = [config.services.prometheus.exporters.node.port];

  environment.pathsToLink = ["/share/zsh"];

  console.keyMap = "neo";

  security.sudo.extraConfig = ''
    Defaults env_keep += "TMUX"
  '';

  programs.zsh.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  users.mutableUsers = false;
  boot.kernelParams = ["nohibernate"];

  sops.secrets."root/aws/credentials" = {
    sopsFile = ../secrets/shared.yaml;
    owner = "root";
    key = "aws/credentials";
    path = "/root/.aws/credentials";
  };
  sops.secrets."root/ssh/builder_id_ed25519" = {
    sopsFile = ../secrets/shared.yaml;
    owner = "root";
    key = "ssh/builder_id_ed25519";
    path = "/root/.ssh/builder_id_ed25519";
  };
  sops.secrets."darkkirb/ssh/builder_id_ed25519" = {
    sopsFile = ../secrets/shared.yaml;
    owner = "darkkirb";
    key = "ssh/builder_id_ed25519";
    path = "/home/darkkirb/.ssh/builder_id_ed25519";
  };
  networking.nameservers = ["fd0d:a262:1fa6:e621:b4e1:08ff:e658:6f49" "fd0d:a262:1fa6:e621:746d:4523:5c04:1453"];
}
