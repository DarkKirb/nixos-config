{...}: {
  documentation.nixos.includeAllModules = true;
  home-manager.users.darkkirb.manual = {
    html.enable = true;
    json.enable = true;
  };
}
