{ config, ... }:
{
  services.openssh.enable = true;
  services.openssh.settings = {
    PermitRootLogin = "yes";
    PasswordAuthentication = false;
    StreamLocalBindUnlink = "yes";
    GatewayPorts = "clientspecified";
    AcceptEnv = "WAYLAND_DISPLAY";
    X11Forwarding = config.system.isGraphical;
  };
  programs.ssh.setXAuthLocation = config.system.isGraphical;
  programs.ssh.knownHosts = {
    "git.chir.rs".publicKey =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE+GanuiV1I08OP8+nNy24+zagQN08rtJnCoU/ixiQNn";
    "instance-20221213-1915.int.chir.rs".publicKey =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE+GanuiV1I08OP8+nNy24+zagQN08rtJnCoU/ixiQNn";
    "nas.int.chir.rs".publicKey =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDhao1I1Kd1gK5bERUdjMxP9yHDrSHYZsTN2TcSk0K/U";
    "not522.tailbab65.ts.net".publicKey =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILpOcmvVODaja3wDdnocb/k6MK7vsh5uH8gpeHR9+/rY";
    "rainbow-resort.int.chir.rs".publicKey =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII9MczPuvEh9XaT6e3emfC+WyMYEpyRu2jDUkt3bBk8W";
    "github.com".publicKey =
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg=";
  };
  networking.firewall.allowedTCPPorts = [ 22 ];
}
