{ ... }: {
  users.users.darkkirb = {
    createHome = true;
    description = "Charlotte 🦝 Delenk";
    extraGroups = [
      "wheel"
    ];
    group = "users";
    home = "/home/alice";
    shell = "/bin/sh";
  };
}
