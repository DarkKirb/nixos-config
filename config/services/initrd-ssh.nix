{ ... }: {
  boot.initrd.network = {
    enable = true;
    ssh.enable = true;
    ssh.hostKeys = [ "/etc/secrets/initrd/ssh_host_ed25519_key" ];
  };
}
