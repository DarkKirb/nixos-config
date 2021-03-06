_: {
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "lotte@chir.rs";
      dnsProvider = "rfc2136";
      credentialsFile = "/run/secrets/security/acme/dns";
    };
    certs."darkkirb.de" = {
      domain = "*.darkkirb.de";
      extraDomainNames = ["darkkirb.de"];
    };
    certs."chir.rs" = {
      domain = "*.chir.rs";
      extraDomainNames = ["chir.rs"];
    };
    certs."int.chir.rs" = {
      domain = "*.int.chir.rs";
    };
    certs."miifox.net" = {
      dnsProvider = "cloudflare";
      credentialsFile = "/run/secrets/security/acme/cloudflare";
      dnsResolver = "1.1.1.1:53";
    };
  };
  services.nginx.group = "acme";
  systemd.services.nginx.serviceConfig.ProtectHome = false;
  sops.secrets."security/acme/dns" = {};
  sops.secrets."security/acme/cloudflare" = {};
}
