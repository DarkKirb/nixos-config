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
      nameServer = "ns1.chir.rs.";
      adminEmail = "lotte@chir.rs";
      serial = 20;
    };
    NS = [
      "ns1.chir.rs."
      "ns2.chir.rs."
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
      (ttl zoneTTL (txt "v=spf1 ip4:138.201.155.128 ip6:2a01:4f8:1c17:d953::/64 -all"))
      (ttl zoneTTL (txt "google-site-verification=qXjyR8La2S_BMayWYxan-9PB16aChjgKMRI2NGSTAds"))
    ];
    DNSKEY = [
      {
        flags.zoneSigningKey = true;
        flags.secureEntryPoint = true;
        algorithm = "ecdsap256sha256";
        publicKey = "5biiUR5bWhxr+PzyniLJp+FKln03EvQTWw+fg88NxwThgvSDL56zEhqkHqh8mObDkEqQ3LdM5LaOxwdDhWVJ9A==";
        ttl = zoneTTL;
      }
      {
        flags.zoneSigningKey = true;
        algorithm = "ecdsap256sha256";
        publicKey = "EuNM0AynEfbLZf5Hn5eMi31X0jW/NxpayoSQpnRuoko9JWQRBg3nPbqTWSPKHaCKrfs6zVRMoHtSq2Hql1Z+dw==";
      }
    ];
    subdomains = {
      _dmarc.TXT = [
        (ttl zoneTTL (txt "v=DMARC1; p=reject; rua=mailto:postmaster@chir.rs;"))
      ];
      _domainkey.subdomains.mail.TXT = [
        (ttl zoneTTL (txt "v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDTZvuDWFmZOOMr9pogMK5lFBjV3nRAjUpFv3o0d4KhbRW/zVrOOdfdt83F6zSLzUqrxSOG3uKVG+J0KR4kX4BbYflSLZ++y91C0Uu5d+o3A8Y/z2vUSe5YVt44IaDQoPCCpuWEYyqKIEaKGXNFPvlsO6y551biM3raNjq5kEpb3wIDAQAB"))
      ];
      _keybase.TXT = [
        (ttl zoneTTL (txt "keybase-site-verification=r044cwg0wOTW-ws35BA5MMRLNwjdTNJ4uOu6kgdTopI"))
      ];
      
      www = createZone {};
      api = createZone {};
      git = createZone {};
      mail = createZone {};
      mc = createZone {};
      ns1 = createZone {};
      ns2 = createZone {};
      hydra = createZone {};
      mastodon = createZone {};
      mastodon-assets.CNAME = [
        "assets-chir-rs.b-cdn.net."
      ];
      matrix = createZone {};
      drone = createZone {};
      invtracker = createZone {};
      akko = createZone {};
      moa = createZone {};
      cache.CNAME = [
        "cache-chir-rs.b-cdn.net."
      ];
      peertube = createZone {};
      mediaproxy.CNAME = [ "mediaproxy-chir-rs.b-cdn.net." ];

      int =
        delegateTo [
          "ns1.chir.rs."
          "ns2.chir.rs."
        ]
        // {
          DS = [
            {
              keyTag = 35133;
              algorithm = "ecdsap256sha256";
              digestType = "sha-256";
              digest = "668D4621260ADD9CE5B272A84ADE20E92FC43CBC59893A5843FA8ED8A356DB2B";
            }
          ];
        };
      _acme-challenge = delegateTo [
        "ns1.chir.rs."
        "ns2.chir.rs."
      ];
    };
  };
in
  zone
