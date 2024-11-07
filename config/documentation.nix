{...}: {
  documentation.nixos.includeAllModules = true;
  documentation.nixos.options.warningsAreErrors = false;
  home-manager.users.darkkirb.manual = {
    html.enable = true;
    json.enable = true;
  };
}
