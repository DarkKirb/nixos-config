{
  config,
  pkgs,
  system,
  ...
}: {
  imports = [
    ./users/darkkirb.nix
    ./users/root.nix
    ./nix.nix
    ./sops.nix
    ./home.nix
    ./services/restic.nix
    ./specialization.nix
    ./services/promtail.nix
    ./env.nix
    ./tailscale.nix
    ./services/otel.nix
  ];
  services.openssh.enable = true;
  environment.systemPackages = with pkgs;
    [
      git
    ]
    ++ (
      if system != "riscv64-linux"
      then [kitty.terminfo]
      else []
    );
  networking.firewall.allowedTCPPorts = [22];
  networking.firewall.allowedUDPPortRanges = [
    {
      from = 60000;
      to = 61000;
    }
  ];

  users.defaultUserShell = pkgs.zsh;

  environment.pathsToLink = ["/share/zsh"];

  console.keyMap = "neo";

  security.sudo.extraConfig = ''
    Defaults env_keep += "TMUX"
  '';

  programs.zsh.enable = true;
  users.mutableUsers = false;

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

  programs.ssh.knownHosts = {
    "nas.int.chir.rs".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDhao1I1Kd1gK5bERUdjMxP9yHDrSHYZsTN2TcSk0K/U";
    "backup.int.chir.rs".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDhao1I1Kd1gK5bERUdjMxP9yHDrSHYZsTN2TcSk0K/U";
  };
  boot.kernel.sysctl = {
    "fs.inotify.max_user_watches" = 524288;
  };
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
  i18n.defaultLocale = "nl_NL.UTF-8";
  nixpkgs.config.permittedInsecurePackages = [
    "olm-3.2.16"
  ];
}
