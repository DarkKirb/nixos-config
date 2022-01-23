{ dns ? (import (builtins.fetchTarball "https://github.com/DarkKirb/dns.nix/archive/master.zip")).outputs, zoneTTL ? 3600 }:
with dns.lib.combinators;
let
  oldFP = [
    # old server
    {
      algorithm = "ed25519";
      mode = "sha1";
      fingerprint = "0050870f1d55b72080f1bebcd872cbd6d4a54260";
    }
    {
      algorithm = "ed25519";
      mode = "sha256";
      fingerprint = "899eb4ac9285578afda3ccbe152ee78d8618b8f3862fef2703e1fc7011e9b8aa";
    }
    {
      algorithm = "rsa";
      mode = "sha1";
      fingerprint = "b53b5a14cec265ced21607810baae30e16a287d0";
    }
    {
      algorithm = "rsa";
      mode = "sha256";
      fingerprint = "f27ceee37b3325b4bc3c94248b01a6b6dedd2e0edaf288561cbcb93b06f4511f";
    }
    {
      algorithm = "ecdsa";
      mode = "sha1";
      fingerprint = "46c7d2641c16e04e09dc277bde6bfa67930e7ef3";
    }
    {
      algorithm = "ecdsa";
      mode = "sha256";
      fingerprint = "bb9cb9e6b74adc2cd16263688d510ec57a842b7f122408536dcca78c1020b742";
    }
  ];
  zone = {
    SOA = {
      nameServer = "ns1.darkkirb.de.";
      adminEmail = "lotte@chir.rs";
      serial = 1;
    };
    NS = [
      "ns1.darkkirb.de."
      "ns2.darkkirb.de."
    ];
    A = [
      (ttl zoneTTL (a "23.88.44.119"))
    ];
    AAAA = [
      (ttl zoneTTL (aaaa "2a01:4f8:c17:14df::1"))
    ];
    MX = [
      (ttl zoneTTL (mx.mx 10 "mail.chir.rs."))
    ];
    SSHFP = oldFP;
  };
in
dns.lib.toString "chir.rs" zone
