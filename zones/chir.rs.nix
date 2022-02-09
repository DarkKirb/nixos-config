{ dns ? (import (builtins.fetchTarball "https://github.com/DarkKirb/dns.nix/archive/master.zip")).outputs, zoneTTL ? 3600 }:
with dns.lib.combinators;
let
  inherit (builtins) hasAttr;
  merge = a: b: (a // b) // (if ((hasAttr "subdomains" a) && (hasAttr "subdomains" b)) then { subdomains = (a.subdomains // b.subdomains); } else { });
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
    HTTPS = [
      {
        svcPriority = 1;
        targetName = ".";
        alpn = [ "http/1.1" "h2" ];
        ipv4hint = [ "138.201.155.128" ];
        ipv6hint = [ "2a01:4f8:1c17:d953:b4e1:8ff:e658:6f49" ];
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
      nameServer = "ns2.darkkirb.de.";
      adminEmail = "lotte@chir.rs";
      serial = 1;
    };
    NS = [
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
      _openpgpkey.subdomains."54b3cc365051676b4d96f469a59f31d12776c4891502822dfbe8a6b2" = {
        OPENPGPKEY = [
          "mQINBGE+CesBEADFhPrY5u3OYM/cYfJHXzdIkFLRaJq/pDda7wkBxSQcsa9E14wbR4CdBYc1OMjH6mJbNhTRxgTcrcV3MamZ8+ZykW1/t7l9dqADBcAprTGDB4pzTk3ZBDMezFZCJfGcBqHhvEQIwde+AHaTGnxO3jrbOBKxVEE++99/x5uCvnW9XXQAidJO44+wRWKamYa/F25zLsf4Yvx/8xJUcA+BozblHJcw3i1SCFqc3UiIs2gnsCe8QvcneomGpNVkfsptBUb7dPaOGEH29ERdjLXqBPlnTRLOTYRtMBDIya6Q+htpckJSsF5h7NqRXRP+ssVYG2CLOU30qvR7aQFkMFhL60lwYVJpJ5oXnwdlwEt3AROvVEEb66K2YrLS9WNRdWlQ4PuAppP8E/e3gZApVOwZAtFSZ1Yk4LaoUcuF23Z3haJOOCyioXCBoVeq4qpWVjz9f5nfw9GATO6IEZGOejJ77ayyMJOpQBfLRq1Adfjqs4MBdCeapwX5cBqJg+tF4ZHAZeeMZGeAvmExreW6qwRUC5crHqcRP6HECevpz+9z2A5dmw6ESsDv3DAh2HyNSCXbF5G7KbS7z5S+HzoKP+tLZ5P24Uj+lFYPSxUUEtJDZ3FjdYnzrSyy/UUUyxk89S37gyPoZlrka5l92apLphUXnm9FqGvobyfPMmmg2tU7sOloQARAQABtCdDaGFybG90dGUgRGVsZW5rIDxkYXJra2lyYkBkYXJra2lyYi5kZT6JAk4EEwEIADgWIQQgbaXh2gkEtu5JFro8713akVrssAUCYT4J6wIbAwULCQgHAgYVCgkICwIEFgIDAQIeAQIXgAAKCRA8713akVrssCodEAC+7szPl5IQG8oPwLxYmVas48wF9d5TKhzVuyLzS8JYtUgWiPYSaaNJbCuoAN/O0a9luvjJhcMMqey9YJa4R9BXpsC5aIEj53TIWx6ZeSd6lzEW/6jTqAFQaIiogUNmJsCSRaegaVPNdLpBwFk4NSry3h2PQxktG+jLLSDOQbqFzYKj5s6v2GGtvoZnNWge6Yd6HDV5GzcCzDsXH05lpeyymvwqgnMzwvDFMLRuACmFCCOfOMrjR0ER0kgwk+fG1l56arpLoXsfYKkdbyAZMFvJmnHDvnvymj8RUQxjR9lX8jDTZYXSQuGm8+J0UB10yWzNXd1/XblFmDT3gaCk9MqtWoGxvCl43DSmRtazW9y/lDpmq4OkF7cN+xVtYCskmUaw8WF8U7RWelCcSxvX/W1rTf7rU7TTA16wPevlueW01mWOy5ndyO0B2QEf6z7y37Tehvw4NHSUelM8wRQp+9/9utSkyb/INRoEnfVSanrJucThgfSIUz8499cQ5CRsMHEJkF8LcMsh2XjsLBG+XhsjZTZY91i3bpmSJF5J9AUxPLdlS6GYq73d+NkoMrqtHJ2L4SM4b46oFIGHWlZ0V5UfHqUVw4aEH8grDCeZ9Dx+R9cu+UFZa2f1lO3KqQ0BBy6qKM3GFmMRsAUnYThRWR+I1BP65MS8iOH04W3g4kXREbQlQ2hhcmxvdHRlIPCfpp0gRGVsZW5rIDxsb3R0ZUBjaGlyLnJzPokCTgQTAQgAOBYhBCBtpeHaCQS27kkWujzvXdqRWuywBQJhvLrSAhsDBQsJCAcCBhUKCQgLAgQWAgMBAh4BAheAAAoJEDzvXdqRWuywxIoP/3bD9UNGt2G8swI7KUMiSRLNuCn+O4jFBU/7RlYeUdtLsvCjpJe7yaJ9LHDQQzhrJUGHIPO67g5O9X0iKEMFyfeK7FTuGvad+Pv/XS/PTb+6Whjxjz+y6MF3tcmJzX+VK3EJ7ZLSTZdXwh9zWhdyPmMYt7qrdjThcX2LBykRWfvA6LwXC9KCCURDNmN/rwYhS0HqixIciOTZbyZNmsbfAZ82bhl9e+IyBrNDgBHdZrschgvtfNZR70I/kB1pphaymhdL9iIk1uKxkwNIoLTGs3kDAnFUc4T+Cin1xws4CrlTcE8CP/9EbcELuzeplJmba1wGg6zkKFrgrQ6iM4YrU/zMIAbOZg4fGicGGJ97skqPwLse0FjogkSGnwPpa7jCFzxFXbf/Iae/JqJDYq3cG/kvpYpCQmCL1ak6s2eXXfx6ul9teWmfdjkrZSXr+4MEKGKPlBXm/7BM/jcAc0oTpGJWu8uQzQ3G4pmlCWApRy1UF7Lh6is1mhUYL9UmWfeQaiIoU0jQBoiRdQhkC59Fmf+oZUSajIT8wXkxGW8N+VP7L3uOQkihXNayAsfynEC5rZy3UzuvG1U+8jEH+vFJzZ5LjgGRVmjqAi6ynvekcJB0Q6fdTrSEN8F17T40oqYy5yHXY+nVQYg1MBzAX9NU9Gzjx2Uxec9cGTuMbVKH57YVuDMEYUd00BYJKwYBBAHaRw8BAQdABP3IYQbzhTfIWJCcj3+SgLBF2Fk3SMyM5imbaqhoECSJAq0EGAEIACAWIQQgbaXh2gkEtu5JFro8713akVrssAUCYUd00AIbAgCBCRA8713akVrssHYgBBkWCgAdFiEEP69eXVNKUODDisozAV43aKcK+8UFAmFHdNAACgkQAV43aKcK+8X2FwD8Crj/QWCgECZ6gXKxBO/Kv1a3Jmyui68z/Q7wkSNnbcsBAJxW8XH1DmszQ+m9qPnOPh1Ozy2oMh6ivxOzvQ7D3sYCz7IP/39mVNTBkFlNQVFXOv08XtYnqpflHTBzlUJLbneWW7sW1UQZmlV4QBYgXkNgP/Qbi6MPTAbJ0YF+wGcUyEX8yRtuTLIUwCUCjHBz4KFJqbRpFzNVcXpyjTSuY/vvHg1uSPUmejEA0M7qvyVqelWTkTfYRjQdSg3jX/UGQkbW5k+WVh4C+UQvbeeiNQbDO7cKHGdagns1G0cmgNZf/GuwfqcYJchEZjtkouXf672WZdRYeEp79/aPyXAWTvzGk67qAQGHmiw5bTGC1VWppou+DDmE0LC2miELDqqas4BZRrFKiVncvnVnbDIAi5rquP5vKbApb+TlofZEmru0LReghBJ73CryWfwXXV6B63zYVzI7N/eLeaYo3HxW3h56nvBJ6+GHW3ZOvwPz+isRNKk6PHQqezKKM3dH3Z15m4TyRHC2BImXaZeD11bJ5nWil1FhvepGcwI1uTwSs4AQSR9APoSaG5NwSK8SPVug8VMsuWcIpl8hx03u6gDgxzzcSSoqMJOwoNjkkQ0i6l+KXnTVo15VvrfLBeriO6rJWR1AIxuHK6rKOT82iMDfkQcnsgLebevU7Tm3sHciqFGnRmULhin7U5mA+sxNku7TBvOsTN+A+CWKglhdoKeHQLVhWNwE68j81zpHNxwjFsFCgN0Pc9k2eC3TWIOAjOYX+i94SexPuDgEYUhA4BIKKwYBBAGXVQEFAQEHQOWXrMIRy85+F1eQdR/85yqdnsICM2FEJwRDgCANhnhZAwEIB4kCNgQYAQgAIBYhBCBtpeHaCQS27kkWujzvXdqRWuywBQJhSEDgAhsMAAoJEDzvXdqRWuywJqsP/iOxdyAM9uMiaB+fFZHzEHFlFGHK+r1H4O3+Og67Z47122hJeQCGcO09PI0rmzsysc5NTqMqUsG9XbUBp5nDDK8FtsjfNomRZd0mG15UuukANBBWLw7U/EzbhFQdQ/rru2bUYIEsRlrumwuLuoSKKScbZ0w3EKJkxCvwFGAGBvpvWqzTAYb4OElKZr3lUZ3E66mxcDTPzP9kNA1n2RWMfwuIkzwkbfTYFaQO3PDKIpu2lmKMzSH4hW2CDoGicezIzShXGEd2qXUZw98Qu5zew2/mVLQjGGjlJtaRtjTEGYR4KtyvSzxITsnZEAuQNmWKBjrXpJLR6JmC5Cgr1zu8yo8BMd/wI3s7821tn+Pp+1sYeY9W/hKzF6SFG+9Eejpkvrf23pjflM24rehpR+2judWtLZIXDLTC8jVUYsGDPRl4ai+E+dZtFABX22DggziHYvx3d9cmhrW3NgmhMaazSMyEFWOW2ksPmnsByNu0jB7TsRx13V9WXft0hSMd2CfvHGmWy1uApq7XmEZo+VLZmFHMEnuG7pDXpdSDmrGfemmbDI77yRecq49iTpLfd2xwoZ5F/tKR9sC/NhCi4JoniKYN59y3fhDvt+8iG4afEpqEI0XFhNL7fhO/yoCKk+uRuNQ7ESFoRGpD3sHtPGapCPIE6S2zeGm1BVLORLhqFZgL"
        ];
      };
      _dmarc.TXT = [
        (ttl zoneTTL (txt "v=DMARC1; p=reject; rua=mailto:postmaster@chir.rs;"))
      ];
      _domainkey.subdomains.mail.TXT = [
        (ttl zoneTTL (txt "v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDTZvuDWFmZOOMr9pogMK5lFBjV3nRAjUpFv3o0d4KhbRW/zVrOOdfdt83F6zSLzUqrxSOG3uKVG+J0KR4kX4BbYflSLZ++y91C0Uu5d+o3A8Y/z2vUSe5YVt44IaDQoPCCpuWEYyqKIEaKGXNFPvlsO6y551biM3raNjq5kEpb3wIDAQAB"))
      ];
      _keybase.TXT = [
        (ttl zoneTTL (txt "keybase-site-verification=r044cwg0wOTW-ws35BA5MMRLNwjdTNJ4uOu6kgdTopI"))
      ];

      www = createZone { };
      api = createZone { };
      git = createZone { };
      mail = createZone { };

      int = delegateTo [
        "ns1.darkkirb.de"
        "ns2.darkkirb.de"
      ] // {
        DS = [{
          keyTag = 35133;
          algorithm = "ecdsap256sha256";
          digestType = "sha-256";
          digest = "668D4621260ADD9CE5B272A84ADE20E92FC43CBC59893A5843FA8ED8A356DB2B";
        }];
      };
      _acme-challenge = delegateTo [
        "ns2.darkkirb.de"
      ];
    };
  };
in
zone
