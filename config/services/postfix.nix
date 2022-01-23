{ pkgs, ... }:
let
  virtual_alias_domains = pkgs.writeText "virtual_alias_domains.cf" ''
    user = postfix
    dbname = postfix
    query = SELECT target_domain FROM alias_domain WHERE alias_domain = '%s' AND active='t';
  '';
  virtual_alias_maps = pkgs.writeText "virtual_alias_maps.cf" ''
    user = postfix
    dbname = postfix
    query = SELECT goto FROM alias WHERE address='%s' AND active='t';
  '';
  virtual_mailbox_domains = pkgs.writeText "virtual_mailbox_domains.cf" ''
    user = postfix
    dbname = postfix
    query = SELECT domain FROM domain WHERE domain = '%s' AND active='t';
  '';
in
{
  nixpkgs.overlays = [
    (curr: prev: {
      postfix = prev.postfix.override {
        withPgSQL = true;
      };
    })
  ];
  services.postfix = {
    enable = true;
    enableSubmission = true;
    enableSubmissions = true;
    destination = [
      "localhost"
      "darkkirb.de"
      "miifox.net"
      "chir.rs"
    ];
    domain = "chir.rs";
    hostname = "mail.chir.rs";
    masterConfig = {
      submission = {
        args = [ "-o" "smtpd_tls_security_level=encrypt" ];
        type = "inet";
      };
    };
    origin = "mail.chir.rs";
    sslCert = "/var/lib/acme/chir.rs/cert.pem";
    sslKey = "/var/lib/acme/chir.rs/key.pem";
    config = {
      smtp_tls_security_level = "encrypt";

      virtual_alias_domains = "pgsql:${virtual_mailbox_domains}";
      virtual_alias_maps = "pgsql:${virtual_alias_maps}";
      virtual_mailbox_domains = "pgsql:${virtual_mailbox_domains}";
      virtual_transport = "lmtp:unix:/run/dovecot/lmtp";
      smtpd_milters = "[fd00:e621:e621:2::2]:11332";
      non_smtpd_milters = "[fd00:e621:e621:2::2]:11332";
      disable_vrfy_command = "yes";
      smtpd_banner = "mail.chir.rs ESMTP NO UCE NO UBE NO RELAYCLIENT=yes YES OwO";
      message_size_limit = "20971520";
      biff = "no";
      smtpd_helo_restrictions = "permit_mynetworks, permit_sasl_authenticated";
      smtpd_helo_required = "yes";
      smtpd_sasl_type = "dovecot";
      smtpd_sasl_path = "/run/dovecot/auth";
      smtpd_sasl_auth_enable = "yes";
      smtpd_tls_auth_only = "yes";
      smtpd_tls_mandatory_protocols = "!SSLv2, !SSLv3, !TLSv1, !TLSv1.1";
      smtpd_tls_protocols = "!SSLv2, !SSLv3, !TLSv1, !TLSv1.1";
      tls_preempt_cipherlist = "no";
    };
  };
  services.postgresql.ensureUsers = [{
    name = "postfix";
    ensurePermissions = {
      "DATABASE \"postfix\"" = "CONNECT";
    };
  }];

}
