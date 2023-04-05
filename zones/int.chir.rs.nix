{
  dns,
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
in {
  SOA = {
    nameServer = "ns1.chir.rs.";
    adminEmail = "lotte@chir.rs";
    serial = 21;
  };
  NS = [
    "ns1.chir.rs."
    "ns2.chir.rs."
    "ns3.chir.rs."
    "ns4.chir.rs."
    "ns1.darkkirb.de."
    "ns2.darkkirb.de."
    "ns1.shitallover.me."
    "ns2.shitallover.me."
  ];
  DNSKEY = [
    {
      flags.zoneSigningKey = true;
      flags.secureEntryPoint = true;
      algorithm = "ecdsap256sha256";
      publicKey = "wB3TYl1UNG1f2p04/ExhCOib2iJD3mNo3F9vrwIBIP0kA94Z5xUVFQUMbSYrUIjA7/oNs/Degpo2RWFwnzFf2A==";
      ttl = zoneTTL;
    }
    {
      flags.zoneSigningKey = true;
      algorithm = "ecdsap256sha256";
      publicKey = "KdE0BQY5RqcHSYo9pgpjVAR1FAtaaF9elTzRhSE1dNKtVaMMhF5JA5s/tYVk1eY7JtiYVAOQkJsUduGTBOosDg==";
      ttl = zoneTTL;
    }
  ];
  subdomains = {
    gateway = {
      A = [
        (ttl zoneTTL (a "10.0.0.1"))
      ];
      AAAA = [
        (ttl zoneTTL (aaaa "fd00:e621:e621::1"))
      ];
    };
    nixos-8gb-fsn1-1 = {
      A = [
        (ttl zoneTTL (a "100.119.226.33"))
      ];
      AAAA = [
        (ttl zoneTTL (aaaa "fd7a:115c:a1e0:ab12:4843:cd96:6277:e221"))
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
      /*
      subdomains = {
      _tcp.subdomains."*".TLSA = [
      {
      certUsage = "dane-ee";
      selector = "spki";
      match = "sha256";
      certificate = "0b85bd8fd152ed8b29a25e7fd69c083138a7bd35d79aea62c111efcf17ede23f";
      ttl = zoneTTL;
      }
      ];
      _udp.subdomains."*".TLSA = [
      {
      certUsage = "dane-ee";
      selector = "spki";
      match = "sha256";
      certificate = "0b85bd8fd152ed8b29a25e7fd69c083138a7bd35d79aea62c111efcf17ede23f";
      ttl = zoneTTL;
      }
      ];
      };
      */
      HTTPS = [
        {
          svcPriority = 1;
          targetName = ".";
          alpn = ["http/1.1" "h2" "h3"];
          ipv4hint = ["100.119.226.33"];
          ipv6hint = ["fd7a:115c:a1e0:ab12:4843:cd96:6277:e221"];
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
    nutty-noon = {
      A = [
        (ttl zoneTTL (a "100.105.131.79"))
      ];
      AAAA = [
        (ttl zoneTTL (aaaa "fd7a:115c:a1e0:ab12:4843:cd96:6269:834f"))
      ];
      SSHFP = [
        {
          algorithm = "rsa";
          mode = "sha1";
          fingerprint = "02e148adb73781d6c60202de7f17a164d3a8e1a4";
          ttl = zoneTTL;
        }
        {
          algorithm = "rsa";
          mode = "sha256";
          fingerprint = "9d7f38a6c8bed75a9bacb253aa172dd4b4a1291ba77c1f07e5b9a0c38a353040";
          ttl = zoneTTL;
        }
        {
          algorithm = "ed25519";
          mode = "sha1";
          fingerprint = "932070039e800bf2ae259b8dbf253342e7ee0da6";
          ttl = zoneTTL;
        }
        {
          algorithm = "ed25519";
          mode = "sha256";
          fingerprint = "78c585ece995f82bd0c23890c7fd59e0fa7d2c1741f303dc9e301b0161e9e2c3";
          ttl = zoneTTL;
        }
      ];
      # TODO: add TLSA
      HTTPS = [
        {
          svcPriority = 1;
          targetName = ".";
          alpn = ["http/1.1" "h2" "h3"];
          ipv4hint = ["100.105.131.79"];
          ipv6hint = ["fd7a:115c:a1e0:ab12:4843:cd96:6269:834f"];
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
    thinkrac = {
      A = [(ttl zoneTTL (a "100.75.9.4"))];
      AAAA = [
        (ttl zoneTTL (aaaa "fd7a:115c:a1e0:ab12:4843:cd96:624b:904"))
      ];
    };
    nas = {
      A = [(ttl zoneTTL (a "100.99.129.7"))];
      AAAA = [
        (ttl zoneTTL (aaaa "fd7a:115c:a1e0:ab12:4843:cd96:6263:8107"))
      ];
      SSHFP = [
        {
          algorithm = "rsa";
          mode = "sha1";
          fingerprint = "13e1173d96b822c98a7b3cd47be2e830f7758671";
          ttl = zoneTTL;
        }
        {
          algorithm = "rsa";
          mode = "sha256";
          fingerprint = "2e87a3fd00918e4f1e47d3b14b59e846ee016a0d3269cb2524c8d28b121e130e";
          ttl = zoneTTL;
        }
        {
          algorithm = "ed25519";
          mode = "sha1";
          fingerprint = "d1df2d244980a5e4dde37eed678b59a2239ca2ac";
          ttl = zoneTTL;
        }
        {
          algorithm = "ed25519";
          mode = "sha256";
          fingerprint = "33d6c993ee3789fb6a2e60c243da7095eb79ce8e522b087f8a31ea400d7b034e";
          ttl = zoneTTL;
        }
      ];
      # TODO: add TLSA
      HTTPS = [
        {
          svcPriority = 1;
          targetName = ".";
          alpn = ["http/1.1" "h2" "h3"];
          ipv4hint = ["100.99.129.7"];
          ipv6hint = ["fd7a:115c:a1e0:ab12:4843:cd96:6263:8107"];
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
    instance-20221213-1915 = {
      A = [(ttl zoneTTL (a "100.99.173.107"))];
      AAAA = [
        (ttl zoneTTL (aaaa "fd7a:115c:a1e0:ab12:4843:cd96:6263:ad6b"))
      ];
    };

    grafana.CNAME = [(ttl zoneTTL (cname "nixos-8gb-fsn1-1"))];
    minio.CNAME = [(ttl zoneTTL (cname "nixos-8gb-fsn1-1"))];
    minio-console.CNAME = [(ttl zoneTTL (cname "nixos-8gb-fsn1-1"))];
    backup.CNAME = [(ttl zoneTTL (cname "nas"))];
    hydra.CNAME = [(ttl zoneTTL (cname "nas"))];
    mastodon.CNAME = [(ttl zoneTTL (cname "nas"))];
    matrix.CNAME = [(ttl zoneTTL (cname "nas"))];
    rspamd.CNAME = [(ttl zoneTTL (cname "nixos-8gb-fsn1-1"))];
    drone.CNAME = [(ttl zoneTTL (cname "nas"))];
    moa.CNAME = [(ttl zoneTTL (cname "nas"))];
    matrix-admin.CNAME = [(ttl zoneTTL (cname "nas"))];
    _acme-challenge = delegateTo [
      "ns1.chir.rs."
      "ns2.chir.rs."
    ];
  };
}
