{ config, lib, ... }:
{
  services.postgresql = lib.mkIf (config.system.isGraphical && !config.system.isInstaller) {
    enable = true;
    extensions = ps: [ ps.postgis ];
    ensureUsers = [
      {
        name = "darkkirb";
        ensureDBOwnership = true;
      }
    ];
    ensureDatabases = [ "darkkirb" ];
  };
  services.pgbouncer.settings.databases =
    lib.mkIf (config.system.isGraphical && !config.system.isInstaller)
      {
        darkkirb = "host=127.0.0.1 port=5432 auth_user=darkkirb dbname=darkkirb";
      };
}
