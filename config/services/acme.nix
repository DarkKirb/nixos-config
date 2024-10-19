{config, ...}: {
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
      dnsProvider = "gcloud";
      credentialsFile = config.sops.secrets."security/acme/gcloud".path;
      dnsResolver = "1.1.1.1:53";
    };
    certs."chir.rs" = {
      domain = "*.chir.rs";
      extraDomainNames = ["chir.rs"];
    };
    certs."int.chir.rs" = {
      domain = "*.int.chir.rs";
    };
    certs."shitallover.me" = {
      domain = "*.shitallover.me";
      extraDomainNames = ["shitallover.me"];
      dnsProvider = "gcloud";
      credentialsFile = config.sops.secrets."security/acme/gcloud".path;
      dnsResolver = "1.1.1.1:53";
    };
    certs."miifox.net" = {
      dnsProvider = "cloudflare";
      credentialsFile = "/run/secrets/security/acme/cloudflare";
      dnsResolver = "1.1.1.1:53";
    };
  };
  sops.secrets."security/acme/dns" = {};
  sops.secrets."security/acme/cloudflare" = {};
  sops.secrets."security/acme/gcloud" = {};
  sops.secrets."security/acme/gcloud.json".owner = "acme";
}
