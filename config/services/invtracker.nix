{
  pkgs,
  invtracker,
  ...
}: let
  port = 19689;
  configFile = builtins.toFile "config.xml" ''
    <?xml version="1.0" encoding="UTF-8"?>
    <config>
      <server host="127.0.0.1" port="${toString port}" />
      <database url="jdbc:sqlite:test.db" />
    </config>
  '';
in {
  systemd.services.invtracker = {
    enable = true;
    description = "InvTracker";
    script = "${invtracker.packages.${pkgs.system}.invtracker-server}/bin/server ${configFile}";
    serviceConfig = {
      User = "invtracker";
      Group = "invtracker";
      WorkingDirectory = "/var/lib/invtracker";
      Restart = "always";
    };
    wantedBy = ["multi-user.target"];
    environment = {
      JAVA_HOME = "${pkgs.openjdk_headless}";
    };
  };
  services.caddy.virtualHosts."invtracker.chir.rs" = {
    useACMEHost = "chir.rs";
    extraConfig = ''
      import baseConfig

      handle /web/* {
        root * ${invtracker.packages.${pkgs.system}.invtracker-web}
        try_files {path} /web/index.html
      }

      handle {
        reverse_proxy http://localhost:${toString port}
      }
    '';
  };
  users.users.invtracker = {
    description = "InvTracker";
    home = "/var/lib/invtracker";
    useDefaultShell = true;
    group = "invtracker";
    isSystemUser = true;
  };
  users.groups.invtracker = {};
  systemd.tmpfiles.rules = [
    "d '/var/lib/invtracker' 0750 invtracker invtracker - -"
    "d '/var/lib/invtracker/media' 0750 invtracker invtracker - -"
  ];
}
