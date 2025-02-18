{
  config,
  lib,
  pkgs,
  ...
}:

let
  adDomain = "ad.chir.rs";
  adWorkgroup = "CHIRRS";
  adNetbiosName = lib.toUpper config.networking.hostName;
  staticIp = "100.97.198.107";
in
{
  networking.search = [ adDomain ];
  networking.nameservers = [ staticIp ];

  # Disable default Samba `smbd` service, we will be using the `samba` server binary
  systemd.services.samba-smbd.enable = false;
  systemd.services.samba = {
    description = "Samba Service Daemon";

    requiredBy = [ "samba.target" ];
    partOf = [ "samba.target" ];

    serviceConfig = {
      ExecStart = "${lib.getExe' config.services.samba.package "samba"} --foreground --no-process-group";
      ExecReload = "${lib.getExe' pkgs.coreutils "kill"} -HUP $MAINPID";
      LimitNOFILE = 16384;
      PIDFile = "/run/samba.pid";
      Type = "notify";
      NotifyAccess = "all"; # may not do anything...
    };
    unitConfig.RequiresMountsFor = "/var/lib/samba";
  };
  services.samba = {
    enable = true;
    package = pkgs.sambaFull;
    nmbd.enable = false;
    winbindd.enable = false;
    settings = {
      global = {
        "dns forwarder" = "1.1.1.1";
        "netbios name" = adNetbiosName;
        realm = lib.toUpper adDomain;
        "server role" = "active directory domain controller";
        workgroup = adWorkgroup;
        "idmap_ldb:use rfc2307" = "yes";
      };
      sysvol = {
        path = "/var/lib/samba/sysvol";
        "read only" = "No";
      };
      netlogon = {
        path = "/var/lib/samba/sysvol/${adDomain}/scripts";
        "read only" = "No";
      };
    };
  };
}
