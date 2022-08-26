{
  pkgs,
  config,
  ...
}: {
  services.postfixadmin = {
    enable = true;
    adminEmail = "lotte@chir.rs";
    database = {
      dbname = "postfix";
      host = "localhost";
      passwordFile = "/run/secrets/services/postfixadmin/dbpassword";
      username = "postfixadmin";
    };
    hostName = "mail.chir.rs";
    setupPasswordFile = "/run/secrets/services/postfixadmin/setupPassword";
    extraConfig = ''
      $CONF['encrypt'] = 'dovecot:ARGON2ID';
      $CONF['dovecotpw'] = '${pkgs.dovecot}/bin/doveadm pw';
    '';
  };
  sops.secrets."services/postfixadmin/dbpassword" = {
    owner = "postfixadmin";
  };
  sops.secrets."services/postfixadmin/setupPassword" = {
    owner = "postfixadmin";
  };
  services.postgresql.ensureDatabases = ["postfix"];
  services.postgresql.ensureUsers = [
    {
      name = "postfixadmin";
      ensurePermissions = {
        "DATABASE \"postfix\"" = "ALL PRIVILEGES";
      };
    }
  ];
  services.caddy.virtualHosts."mail.chir.rs" = {
    useACMEHost = "chir.rs";
    extraConfig = ''
      import baseConfig

      php_fastcgi unix:${config.services.phpfpm.pools.phpfpm.socket}
    '';
  };
  services.phpfpm.pools.postfixadmin.settings."listen.group" = "acme"; # there is no nginx group
  services.phpfpm.pools.postfixadmin.group = "dovecot";
}
