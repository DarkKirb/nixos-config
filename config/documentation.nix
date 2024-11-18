{ ... }:
{
  documentation.nixos.includeAllModules = true;
  documentation.nixos.options.warningsAreErrors = false;
  /*
    home-manager.users.darkkirb =
    {
      lib,
      config,
      systemConfig,
      ...
    }:
    {
      manual = lib.mkIf (config.home.version.release == systemConfig.system.nixos.release) {
        html.enable = true;
        json.enable = true;
      };
    };
  */
}
