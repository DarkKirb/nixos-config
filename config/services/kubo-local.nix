{
  pkgs,
  config,
  lib,
  ...
}: {
  services.kubo = {
    package = pkgs.kubo-orig;
    autoMigrate = true;
    emptyRepo = true;
    enable = true;
    enableGC = true;
    settings = {
      Addresses = {
        API = "/ip4/127.0.0.1/tcp/36307";
        Gateway = "/ip4/127.0.0.1/tcp/41876";
      };
      Experimental = {
        FilestoreEnabled = true;
        UrlstoreEnabled = true;
      };
      Gateway.PublicGateways."ipfs.chir.rs" = {
        Paths = ["/ipfs" "/ipns"];
        UseSubdomains = false;
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    4001
    4002
  ];
  networking.firewall.allowedUDPPorts = [
    4001
  ];
}
