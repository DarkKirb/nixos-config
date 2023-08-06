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
  createFullZone = merge (createZone {
    A = [
      (ttl zoneTTL (a "130.162.60.127"))
      (ttl zoneTTL (a "138.201.155.128"))
    ];
    AAAA = [
      (ttl zoneTTL (aaaa "2603:c020:8009:f100:f09a:894d:ef57:a278"))
      (ttl zoneTTL (aaaa "2a01:4f8:1c17:d953:b4e1:8ff:e658:6f49"))
    ];
    HTTPS = [
      {
        svcPriority = 1;
        targetName = ".";
        alpn = ["http/1.1" "h2" "h3"];
        ipv4hint = ["138.201.155.128" "130.162.60.127"];
        ipv6hint = ["2a01:4f8:1c17:d953:b4e1:8ff:e658:6f49" "2603:c020:8009:f100:f09a:894d:ef57:a278"];
        ttl = zoneTTL;
      }
    ];
  });
  zone = createZone {
    SOA = {
      nameServer = "ns1.chir.rs.";
      adminEmail = "lotte@chir.rs";
      serial = 36;
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
      mc = createZone oracleBase;
      ns1 = createZone {};
      ns2 = createZone {};
      ns3 = createZone oracleBase;
      ns4 = createZone oracleBase;
      hydra = createZone {};
      mastodon = createZone {};
      mastodon-assets.CNAME = [
        "assets-chir-rs.b-cdn.net."
      ];
      matrix = createZone {};
      woodpecker = createZone {};
      akko = createZone {};
      peertube = createZone {};
      mediaproxy.CNAME = ["mediaproxy-chir-rs.b-cdn.net."];
      attic = createFullZone {};
      cloud = createZone oracleBase;
      lotte = createZone {};
      ipfs-nocdn = createZone oracleBase;
      ipfs.CNAME = ["ipfs-chir-rs.b-cdn.net."];
      status = createZone oracleBase;

      int =
        delegateTo [
          "ns1.chir.rs."
          "ns2.chir.rs."
          "ns3.chir.rs."
          "ns4.chir.rs."
          "ns1.darkkirb.de."
          "ns2.darkkirb.de."
          "ns1.shitallover.me."
          "ns2.shitallover.me."
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
