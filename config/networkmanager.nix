{...}: {
  networking.networkmanager.enable = true;
  users.users.darkkirb.extraGroups = ["networkmanager"];
}
