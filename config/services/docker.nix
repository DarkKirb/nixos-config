_: {
  virtualisation.docker = {
    autoPrune = {
      dates = "weekly";
      enable = true;
      flags = ["--all"];
    };
    enable = true;
  };
  users.users.darkkirb.extraGroups = ["docker"];
}
