{ ... }: {
  users.users.darkkirb = {
    createHome = true;
    description = "Charlotte 🦝 Delenk";
    extraGroups = [
      "wheel"
    ];
    group = "users";
    home = "/home/darkkirb";
    isNormalUser = true;
    uid = 1000;
  };
}
