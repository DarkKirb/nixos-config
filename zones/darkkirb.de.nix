{
  dns ? (import (builtins.fetchTarball "https://github.com/DarkKirb/dns.nix/archive/master.zip")).outputs,
  zoneTTL ? 3600,
}:
with dns.lib.combinators; let
  inherit (builtins) hasAttr;
  merge = a: b:
    (a // b)
    // (
      if ((hasAttr "subdomains" a) && (hasAttr "subdomains" b))
      then {subdomains = a.subdomains // b.subdomains;}
      else {}
    );
  oracleBase = {
    A = [
      (ttl zoneTTL (a "130.162.60.127"))
    ];
    AAAA = [
      (ttl zoneTTL (aaaa "2603:c020:8009:f100:f09a:894d:ef57:a278"))
    ];
    SSHFP = [
      {
        algorithm = "rsa";
        mode = "sha1";
        fingerprint = "b44a837703b22d8cbc2ca4e7019af4bcb0185348";
        ttl = zoneTTL;
      }
      {
        algorithm = "rsa";
        mode = "sha256";
        fingerprint = "8f276ce01188fdd2bbf2aaa03d477c58c911a6c1f9bee3f8ab35ca4b42aa19a9";
        ttl = zoneTTL;
      }
      {
        algorithm = "ed25519";
        mode = "sha1";
        fingerprint = "8dfd784c5f239822b086dc4fa7c058f260331e5d";
        ttl = zoneTTL;
      }
      {
        algorithm = "ed25519";
        mode = "sha256";
        fingerprint = "82d51bd3ab43af3b94801c6b68812c4f1db013ac5b53a466fbcdbb955de6d3e5";
        ttl = zoneTTL;
      }
    ];
    HTTPS = [
      {
        svcPriority = 1;
        targetName = ".";
        alpn = ["http/1.1" "h2" "h3"];
        ipv4hint = ["130.162.60.127"];
        ipv6hint = ["2603:c020:8009:f100:f09a:894d:ef57:a278"];
        ttl = zoneTTL;
      }
    ];
  };
  zoneBase = {
    A = [
      (ttl zoneTTL (a "138.201.155.128"))
    ];
    AAAA = [
      (ttl zoneTTL (aaaa "2a01:4f8:1c17:d953:b4e1:8ff:e658:6f49"))
    ];
    SSHFP = [
      {
        algorithm = "rsa";
        mode = "sha1";
        fingerprint = "97b910c37194cd98e7edca2d68104f4531721c22";
        ttl = zoneTTL;
      }
      {
        algorithm = "rsa";
        mode = "sha256";
        fingerprint = "7915470f9275116889d5ca1fdbea20416d8372636c3d63653b272308608cf70f";
        ttl = zoneTTL;
      }
      {
        algorithm = "ed25519";
        mode = "sha1";
        fingerprint = "1aff467e745a8d68ba032dd3d54597e10d31ccf8";
        ttl = zoneTTL;
      }
      {
        algorithm = "ed25519";
        mode = "sha256";
        fingerprint = "e6dcdb73dc381ee2b354528cdaf8552364e75c34316d7e0c9819801daea5c951";
        ttl = zoneTTL;
      }
    ];
    HTTPS = [
      {
        svcPriority = 1;
        targetName = ".";
        alpn = ["http/1.1" "h2" "h3"];
        ipv4hint = ["138.201.155.128"];
        ipv6hint = ["2a01:4f8:1c17:d953:b4e1:8ff:e658:6f49"];
        ttl = zoneTTL;
      }
    ];
    CAA = [
      {
        issuerCritical = false;
        tag = "issue";
        value = "letsencrypt.org";
        ttl = zoneTTL;
      }
      {
        issuerCritical = false;
        tag = "issuewild";
        value = "letsencrypt.org";
        ttl = zoneTTL;
      }
      {
        issuerCritical = false;
        tag = "iodef";
        value = "mailto:lotte@chir.rs";
        ttl = zoneTTL;
      }
    ];
  };
  createZone = merge zoneBase;
  zone = createZone {
    SOA = {
      nameServer = "ns1.darkkirb.de.";
      adminEmail = "lotte@chir.rs";
      serial = 5;
    };
    NS = [
      "ns1.chir.rs."
      "ns2.chir.rs."
      "ns3.chir.rs."
      "ns4.chir.rs."
      "ns1.darkkirb.de."
      "ns2.darkkirb.de."
    ];
    MX = [
      (ttl zoneTTL (mx.mx 10 "mail.chir.rs."))
    ];
    SRV = [
      {
        service = "submission";
        proto = "tcp";
        port = 587;
        target = "mail.chir.rs.";
      }
      {
        service = "imap";
        proto = "tcp";
        port = 143;
        target = "mail.chir.rs.";
      }
      {
        service = "imaps";
        proto = "tcp";
        port = 993;
        target = "mail.chir.rs.";
      }
      {
        service = "pop3";
        proto = "tcp";
        port = 110;
        target = "mail.chir.rs.";
      }
      {
        service = "pop3s";
        proto = "tcp";
        port = 995;
        target = "mail.chir.rs.";
      }
    ];
    TXT = [
      (ttl zoneTTL (txt "v=spf1 ip4:138.201.155.128 ip6:2a01:4f8:1c17:d953/64 -all"))
      (ttl zoneTTL (txt "google-site-verification=f2XWRDvD4F99pM7ux7sMtVJ9ZGtjKRLI_rfcO2IWIMI"))
    ];
    DNSKEY = [
      {
        flags.zoneSigningKey = true;
        flags.secureEntryPoint = true;
        algorithm = "ecdsap256sha256";
        publicKey = "FZklP7KowbXVjfkT5ndAE60QFvaKoghhLY2TavukRBGFA8pyGm+ce9QHekbrjE14q8sb5x0uXl4VdyDIUNZ3XQ==";
        ttl = zoneTTL;
      }
      {
        flags.zoneSigningKey = true;
        algorithm = "ecdsap256sha256";
        publicKey = "WH9JM7Qvi2Hz3bCp7O5/WFLNdKUA/2aUkQqByfhaItfqoAm+hw6x4Qj8+umu5EDyo2A/HD/h9b/eO3zVq6pebw==";
      }
    ];
    subdomains = {
      _dmarc.TXT = [
        (ttl zoneTTL (txt "v=DMARC1; p=quarantine; rua=mailto:dmarc@chir.rs; ruf=dmarc@chir.rs; fo=1; adkim=s; aspf=s; sp=reject;"))
      ];
      _domainkey.subdomains = {
        dkim.TXT = [
          (ttl zoneTTL (txt "v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDk4XK4c7xWGIalV+yTj5F8B2eXOeFtp0p9VNMlG/dZMv1GGS9hUBEkZOOYhAuE2GhKhHsGtxMalGAIbCqJJglVBLTxDerPGLRAsgZ9EZCyhIh9ebOqv0SfhTfdoz6RZkNrB2DK4nnvzaOa0NQzp+a8a5pAN6niDFBbTF3FFBwkOQIDAQAB"))
        ];
        mail.TXT = [
          (ttl zoneTTL (txt "v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDHmbBT9OJwDu5x7C2C/WhzeHirrxAlLwuh8Z9q7UBGS98MsLbS1NnCvZic4N3H/z80RHABF9KFhvJWy60NhM+UKWDEYSlgc8Z3KJZjuqOCUsajjf2cdhaTOKLbu57388tjghBD0cpK3mdqPU5aw2GY4jJR4YC4c0fqJ6vRTvyOSwIDAQAB"))
        ];
      };
      _keybase.TXT = [
        (ttl zoneTTL (txt "keybase-site-verification=9DC6G-moMF8zfcm7_lpjhh2cvT9gL4hHV5yQqf_RgBk"))
      ];
      _acme-challenge = delegateTo [
        "ns1.chir.rs."
        "ns2.chir.rs."
      ];
      www = createZone {};
      static = createZone {};
      ns1 = createZone {};
      ns2 = createZone oracleBase;
    };
  };
in
  zone
