{ ... }:
{
  services.openssh.enable = true;
  services.openssh.settings = {
    PermitRootLogin = "yes";
    PasswordAuthentication = false;
  };
  programs.ssh.knownHosts = {
    "rainbow-resort.int.chir.rs".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII9MczPuvEh9XaT6e3emfC+WyMYEpyRu2jDUkt3bBk8W";
    "instance-20221213-1915.int.chir.rs".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE+GanuiV1I08OP8+nNy24+zagQN08rtJnCoU/ixiQNn";
    "not522.tailbab65.ts.net".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILpOcmvVODaja3wDdnocb/k6MK7vsh5uH8gpeHR9+/rY";
  };
  networking.firewall.allowedTCPPorts = [ 22 ];
}
