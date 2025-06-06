{
  dns,
  zoneTTL ? 3600,
}:
with dns.lib.combinators;
let
  inherit (builtins) hasAttr;
  merge =
    a: b:
    (a // b)
    // (
      if ((hasAttr "subdomains" a) && (hasAttr "subdomains" b)) then
        { subdomains = a.subdomains // b.subdomains; }
      else
        { }
    );
in
{
  SOA = {
    nameServer = "ns1.chir.rs.";
    adminEmail = "lotte@chir.rs";
    serial = 44;
  };
  NS = [
    "ns1.chir.rs."
    "ns2.chir.rs."
    "ns3.chir.rs."
    "ns4.chir.rs."
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
          alpn = [
            "http/1.1"
            "h2"
            "h3"
          ];
          ipv4hint = [ "100.119.226.33" ];
          ipv6hint = [ "fd7a:115c:a1e0:ab12:4843:cd96:6277:e221" ];
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
      A = [ (ttl zoneTTL (a "100.95.136.81")) ];
      AAAA = [
        (ttl zoneTTL (aaaa "fd7a:115c:a1e0::63df:8851"))
      ];
    };
    nas = {
      A = [ (ttl zoneTTL (a "100.97.198.107")) ];
      AAAA = [
        (ttl zoneTTL (aaaa "fd7a:115c:a1e0::2401:c66b"))
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
          alpn = [
            "http/1.1"
            "h2"
            "h3"
          ];
          ipv4hint = [ "100.99.129.7" ];
          ipv6hint = [ "fd7a:115c:a1e0:ab12:4843:cd96:6263:8107" ];
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
      A = [ (ttl zoneTTL (a "100.99.173.107")) ];
      AAAA = [
        (ttl zoneTTL (aaaa "fd7a:115c:a1e0:ab12:4843:cd96:6263:ad6b"))
      ];
    };
    vf2 = {
      A = [ (ttl zoneTTL (a "100.80.150.39")) ];
      AAAA = [
        (ttl zoneTTL (aaaa "fd7a:115c:a1e0::5a01:9627"))
      ];
    };
    rainbow-resort = {
      A = [ (ttl zoneTTL (a "100.115.217.35")) ];
      AAAA = [
        (ttl zoneTTL (aaaa "fd7a:115c:a1e0::4601:d923"))
      ];
    };

    grafana.CNAME = [ (ttl zoneTTL (cname "nixos-8gb-fsn1-1")) ];
    minio.CNAME = [ (ttl zoneTTL (cname "nixos-8gb-fsn1-1")) ];
    minio-console.CNAME = [ (ttl zoneTTL (cname "nixos-8gb-fsn1-1")) ];
    backup.CNAME = [ (ttl zoneTTL (cname "nas")) ];
    hydra.CNAME = [ (ttl zoneTTL (cname "rainbow-resort")) ];
    moa.CNAME = [ (ttl zoneTTL (cname "nas")) ];
    matrix.CNAME = [ (ttl zoneTTL (cname "nas")) ];
    jellyfin.CNAME = [ (ttl zoneTTL (cname "rainbow-resort")) ];
    _acme-challenge = delegateTo [
      "ns1.chir.rs."
      "ns2.chir.rs."
    ];
  };
}
