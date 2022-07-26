_: {
  virtualisation.docker = {
    autoPrune = {
      dates = "weekly";
      enable = true;
      flags = ["--all"];
    };
    enable = true;
    storageDriver = "zfs";
  };
  users.users.darkkirb.extraGroups = ["docker"];
}
