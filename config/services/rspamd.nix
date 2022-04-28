{ config, lib, ... }:
{
  services = {
    # TODO: Antivirus

    rspamd = {
      enable = true;
      locals = {
        "dkim_signing.conf".text = builtins.toJSON {
          domain = {
            "darkkirb.de" = {
              selector = "dkim";
              path = "${config.sops.secrets."services/rspamd/dkim/darkkirb.de".path}";
            };
            "miifox.net" = {
              selector = "dkim";
              path = "${config.sops.secrets."services/rspamd/dkim/miifox.net".path}";
            };
            "chir.rs" = {
              selector = "dkim";
              path = "${config.sops.secrets."services/rspamd/dkim/chir.rs".path}";
            };
          };
        };
        "dmarc.conf".text = builtins.toJSON {
          actions = {
            reject = "reject";
            quarantine = "quarantine";
            softfail = "add_header";
          };
        };
        "greylist.conf".text = builtins.toJSON {
          greylist_min_score = 0;
        };
        "hfilter.conf".text = builtins.toJSON {
          helo_enabled = true;
          hostname_enabled = true;
          url_enabled = true;
          from_enabled = true;
          rcpt_enabled = true;
          mid_enabled = true;
        };
        "history.conf".text = builtins.toJSON {
          nrows = 1000;
          subject_privacy = true;
        };
        "milter.conf".text = builtins.toJSON {
          use = [
            "authentication-results"
            "fuzzy-hashes"
            "spam-header"
            "stat-signature"
            "x-rspamd-queue-id"
            "x-rspamd-result"
            "x-rspamd-server"
            "x-rspamd-bar"
            "x-spam-status"
          ];
        };
        "mx_check.conf".text = builtins.toJSON {
          enabled = true;
        };
        "neural.conf".text = builtins.toJSON {
          enabled = true;
          rules = {
            LONG = {
              train = {
                max_trains = 5000;
                max_usages = 200;
                max_iterations = 25;
                learning_rate = 0.01;
              };
              symbol_spam = "NEURAL_SPAM_LONG";
              symbol_ham = "NEURAL_HAM_LONG";
              ann_expire = "365d";
            };
            SHORT = {
              train = {
                max_trains = 5000;
                max_usages = 2;
                max_iterations = 25;
                learning_rate = 0.01;
              };
              symbol_spam = "NEURAL_SPAM_SHORT";
              symbol_ham = "NEURAL_HAM_SHORT";
              ann_expire = "30d";
            };
          };
        };
        "neural_group.conf".text = builtins.toJSON {
          symbols = {
            NEURAL_SPAM_LONG = {
              weight = 3.0; # sample weight
              description = "Neural network spam (long)";
            };
            NEURAL_HAM_LONG = {
              weight = -3.0; # sample weight
              description = "Neural network ham (long)";
            };
            NEURAL_SPAM_SHORT = {
              weight = 2.0; # sample weight
              description = "Neural network spam (short)";
            };
            NEURAL_HAM_SHORT = {
              weight = -1.0; # sample weight
              description = "Neural network ham (short)";
            };
          };
        };
        "phishing.conf".text = builtins.toJSON {
          openphish_enabled = true;
        };
        "reputation.conf".text = builtins.toJSON {
          rules = {
            ip_reputation = {
              selector.type = "ip";
              backend.type = "redis";
              symbol = "IP_REPUTATION";
            };
            spf_reputation = {
              selector.type = "spf";
              backend.type = "redis";
              symbol = "SPF_REPUTATION";
            };
            dkim_reputation = {
              selector.type = "dkim";
              backend.type = "redis";
              symbol = "DKIM_REPUTATION";
            };
            asn_reputation = {
              selector.type = "generic";
              selector.selector = "asn";
              backend.type = "redis";
              symbol = "ASN_REPUTATION";
            };
            country_reputation = {
              selector.type = "generic";
              selector.selector = "country";
              backend.type = "redis";
              symbol = "COUNTRY_REPUTATION";
            };
          };
        };
        "replies.conf".text = builtins.toJSON {
          expire = "7d";
          symbol = "REPLY";
        };
        "redis.conf".text = builtins.toJSON {
          servers = "${config.services.redis.servers.rspamd.bind}:${toString config.services.redis.servers.rspamd.port}";
        };
      };
      workers = {
        normal = {
          includes = [ "$CONFDIR/worker-normal.inc" ];
          bindSockets = [ "*:11332" ];
        };
        controller = {
          includes = [ "$CONFDIR/worker-controller.inc" ];
          bindSockets = [ "*:11334" ];
        };
      };

    };
    redis.servers.rspamd = {
      enable = true;
      bind = "127.0.0.1";
      databases = 1;
      port = 6380;
      settings = {
        maxmemory = "500mb";
        maxmemory-policy = "volatile-ttl";
      };
    };
    nginx.virtualHosts."rspamd.int.chir.rs" =
      let
        listenIPs = (import ../../utils/getInternalIP.nix config).listenIPs;
        listenStatements = lib.concatStringsSep "\n" (builtins.map (ip: "listen ${ip}:443 http3;") listenIPs) + ''
          add_header Alt-Svc 'h3=":443"';
        '';
      in
      {
        listenAddresses = listenIPs;
        sslCertificate = "/var/lib/acme/int.chir.rs/cert.pem";
        sslCertificateKey = "/var/lib/acme/int.chir.rs/key.pem";
        locations."/" = {
          proxyPass = "http://127.0.0.1:11334/";
          proxyWebsockets = true;
        };
      };
  };
  sops.secrets."services/rspamd/dkim/darkkirb.de" = { owner = "rspamd"; };
  sops.secrets."services/rspamd/dkim/miifox.net" = { owner = "rspamd"; };
  sops.secrets."services/rspamd/dkim/chir.rs" = { owner = "rspamd"; };
  networking.nameservers = lib.mkForce [ "fd0d:a262:1fa6:e621:b4e1:8ff:e658:6f49" ];
  networking.firewall.interfaces."wg0".allowedTCPPorts = [
    11332
    11334
  ];
}
