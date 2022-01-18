{ ... }: {
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "lotte@chir.rs";
      dnsProvider = "rfc2136";
      credentialsFile = "/run/secrets/security/acme/dns";
    };
    certs."darkkirb.de" = {
      domain = "*.darkkirb.de";
      extraDomainNames = [ "darkkirb.de" ];
    };
    certs."chir.rs" = {
      domain = "*.chir.rs";
      extraDomainNames = [ "chir.rs" ];
    };
    certs."int.chir.rs" = {
      domain = "*.int.chir.rs";
    };
  };
  services.nginx.group = "acme";
  sops.secrets."security/acme/dns" = { };
}
