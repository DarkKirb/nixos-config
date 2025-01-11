{ config, ... }:
{
  services.postgresql = {
    enable = config.isGraphical && !config.isInstaller;
    extensions = ps: [ ps.postgis ];
    ensureUsers = [
      {
        name = "darkkirb";
        ensureDBOwnership = true;
      }
    ];
    ensureDatabases = [ "darkkirb" ];
  };
  services.pgbouncer.settings.databases = {
    darkkirb = "host=127.0.0.1 port=5432 auth_user=darkkirb dbname=darkkirb";
  };
}
