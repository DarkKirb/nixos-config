{ pkgs, config, ... }:
let
  listenIP = (import ../../utils/getInternalIP.nix config).listenIP;
  sieves = import ../../packages/sieves.nix pkgs;
in
{

  nixpkgs.overlays = [
    (curr: prev: {
      dovecot = prev.dovecot.override {
        withPgSQL = true;
      };
    })
  ];
  services.dovecot2 = {
    enable = true;
    enableImap = true;
    enableLmtp = true;
    enablePop3 = true;
    enableQuota = true;
    modules = [ pkgs.dovecot_pigeonhole ];
    mailGroup = "dovecot";
    mailUser = "dovecot";
    mailLocation = "maildir:/var/vmail/%d/%n";
    mailPlugins = {
      globally.enable = [
        "old_stats"
      ];
      perProtocol = {
        imap.enable = [
          "imap_sieve"
        ];
        lda.enable = [
          "sieve"
        ];
        lmtp.enable = [
          "sieve"
        ];
      };
    };
    mailboxes = {
      Drafts = {
        specialUse = "Drafts";
        auto = "subscribe";
      };
      Junk = {
        specialUse = "Junk";
        auto = "subscribe";
      };
      Trash = {
        specialUse = "Trash";
        auto = "subscribe";
      };
      Sent = {
        specialUse = "Sent";
        auto = "subscribe";
      };
      "Sent Messages" = {
        specialUse = "Sent";
      };
      "virtual/All" = {
        specialUse = "All";
        auto = "subscribe";
      };
    };
    sslServerCert = "/var/lib/acme/chir.rs/cert.pem";
    sslServerKey = "/var/lib/acme/chir.rs/key.pem";
    extraConfig = ''
      service old-stats {
        unix_listener old-stats {
          user = dovecot-exporter
          group = dovecot-exporter
          mode = 0660
        }
        fifo_listener old-stats-mail {
          mode = 0660
          user = dovecot
          group = dovecot
        }
        fifo_listener old-stats-user {
          mode = 0660
          user = dovecot
          group = dovecot
        }
      }
      plugin {
        old_stats_refresh = 30 secs
        old_stats_track_cmds = yes
      }
      plugin {
        sieve_plugins = sieve_imapsieve sieve_extprograms
        # From elsewhere to Spam folder or flag changed in Spam folder
        imapsieve_mailbox1_name = Junk
        imapsieve_mailbox1_causes = COPY FLAG
        imapsieve_mailbox1_before = file:${sieves.report-spam}/report-spam.sieve

        # From Spam folder to elsewhere
        imapsieve_mailbox2_name = *
        imapsieve_mailbox2_from = Junk
        imapsieve_mailbox2_causes = COPY
        imapsieve_mailbox2_before = file:${sieves.report-ham}/report-ham.sieve

        sieve_pipe_bin_dir = /nix/store

        sieve_global_extensions = +vnd.dovecot.pipe
        sieve = ${sieves.default}/default.sieve
      }
      disable_plaintext_auth = yes
      auth_mechanisms = plain login

      passdb {
        driver = sql
        args = /run/secrets/services/dovecot/dovecot-sql.conf.ext
      }
      userdb {
        driver = prefetch
      }
      userdb {
        driver = sql
        args = /run/secrets/services/dovecot/dovecot-sql.conf.ext
      }
      service auth {
        unix_listener /run/dovecot2/auth {
          mode = 0660
          user = postfix
          group = postfix
        }
      }
      first_valid_uid = 76
      last_valid_uid = 76
    '';
    user = "dovecot";
    group = "dovecot";
    sieveScripts = {
      after = builtins.toFile "spam.sieve" ''
        require "fileinto";

        if header :is "X-Spam" "Yes" {
            fileinto "Junk";
            stop;
        }
      '';
    };

  };
  services.prometheus.exporters.dovecot = {
    enable = true;
    listenAddress = listenIP;
  };
  sops.secrets."services/dovecot/rspamd_password" = { owner = "dovecot"; };
  sops.secrets."services/dovecot/dovecot-sql.conf.ext" = { owner = "dovecot"; };
  services.postgresql.ensureUsers = [{
    name = "dovecot";
    ensurePermissions = {
      "DATABASE \"postfix\"" = "CONNECT";
    };
  }];
  networking.firewall.allowedTCPPorts = [
    110 # POP3
    143 # IMAP
    993 # IMAPS
    995 # POP3S
  ];
}
