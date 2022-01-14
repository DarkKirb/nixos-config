{ ... }: {
  security.acme = {
    acceptTerms = true;
    email = "lotte@chir.rs";
    certs."darkkirb.de" = {
      domain = "*.darkkirb.de";
      extraDomains = [ "darkkirb.de" ];
      dnsProvider = "rfc2136";
      credentialsFile = "/run/secrets/security/acme/dns";
    };
    certs."chir.rs" = {
      domain = "*.chir.rs";
      extraDomains = [ "chir.rs" ];
      dnsProvider = "rfc2136";
      credentialsFile = "/run/secrets/security/acme/dns";
    };
    certs."int.chir.rs" = {
      domain = "*.int.chir.rs";
      dnsProvider = "rfc2136";
      credentialsFile = "/run/secrets/security/acme/dns";
    };
  };
}
