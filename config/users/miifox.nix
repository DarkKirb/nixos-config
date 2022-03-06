{ ... }: {
  users.users.miifox = {
    createHome = true;
    description = "Miifox";
    group = "users";
    home = "/home/miifox";
    isNormalUser = true;
    uid = 1001;
  };
  home-manager.users.miifox = import ../home-manager/miifox.nix;
  systemd.slices."user-1001".sliceConfig = {
    CPUQuota = "100%";
    MemoryHigh = "1G";
    MemoryMax = "1.1G";
  };
  services.postgresql.ensureDatabases = [ "miifox" ];
  services.postgresql.ensureUsers = [{
    name = "miifox";
    ensurePermissions = { "DATABASE miifox" = "ALL PRIVILEGES"; };
  }];
  services.nginx.virtualHosts."miifox.net" = {
    acmeRoot = "/home/miifox/miifox.net";
    sslCertificate = "/var/lib/acme/miifox.net/cert.pem";
    sslCertificateKey = "/var/lib/acme/miifox.net/key.pem";
    locations."/" = {
      root = "/home/miifox/miifox.net";
    };
  };
}
