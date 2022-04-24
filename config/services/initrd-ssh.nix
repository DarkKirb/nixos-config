{ ... }: {
  boot.initrd.network = {
    enable = true;
    ssh.enable = true;
  };
}
