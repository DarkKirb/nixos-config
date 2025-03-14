{
  config,
  pkgs,
  lib,
  ...
}:
let
  gcloud = pkgs.writeText "gcloud" "GCE_SERVICE_ACCOUNT_FILE=${
    config.sops.secrets."security/acme/gcloud.json".path
  }";
in
{
  options.security.acme.enable = lib.mkEnableOption "enable ACME";
  config = lib.mkIf config.security.acme.enable {
    security.acme = {
      acceptTerms = true;
      defaults = {
        email = "lotte@chir.rs";
        dnsProvider = "rfc2136";
        credentialsFile = config.sops.secrets."security/acme/dns".path;
      };
      certs."darkkirb.de" = {
        domain = "*.darkkirb.de";
        extraDomainNames = [ "darkkirb.de" ];
        dnsProvider = "gcloud";
        credentialsFile = gcloud;
        dnsResolver = "1.1.1.1:53";
      };
      certs."chir.rs" = {
        domain = "*.chir.rs";
        extraDomainNames = [ "chir.rs" ];
      };
      certs."int.chir.rs" = {
        domain = "*.int.chir.rs";
      };
    };
    sops.secrets."security/acme/dns".sopsFile = ./secrets.yaml;
    sops.secrets."security/acme/gcloud.json" = {
      owner = "acme";
      sopsFile = ./secrets.yaml;
    };
    environment.persistence."/persistent".directories = [
      "/var/lib/acme"
    ];
  };
}
