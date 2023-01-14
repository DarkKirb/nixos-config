{config, ...}: {
  users.users.remote-build = {
    createHome = true;
    description = "Remote builder";
    group = "users";
    home = "/home/remote-build";
    isNormalUser = true;
    uid = 1002;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINN5Q/L2FyB3DIgdJRYnTGHW3naw5VQ9coOdwHYmv0aZ darkkirb@thinkrac"
    ];
  };
}
