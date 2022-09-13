# Taken from https://github.com/pSub/configs/blob/master/nixops/configurations/server.pascal-wittmann.de/modules/systemd-email-notify.nix
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  sendmail =
    pkgs.writeScript "sendmail"
    ''
      #!/bin/sh

      ${pkgs.msmtp}/bin/msmtp -t <<ERRMAIL
      To: $1
      From: ${config.systemd.email-notify.mailFrom}
      Subject: Status of service $2
      Content-Transfer-Encoding: 8bit
      Content-Type: text/plain; charset=UTF-8

      $(systemctl status --full "$2")
      ERRMAIL
    '';
in {
  options = {
    systemd.email-notify.mailTo = mkOption {
      type = types.str;
      default = null;
      description = "Email address to which the service status will be mailed.";
    };

    systemd.email-notify.mailFrom = mkOption {
      type = types.str;
      default = null;
      description = "Email address from which the service status will be mailed.";
    };

    systemd.services = mkOption {
      type = with types;
        attrsOf (
          submodule {
            config.onFailure = ["email@%n.service"];
          }
        );
    };
  };

  config = {
    systemd.services."email@" = {
      description = "Sends a status mail via sendmail on service failures.";
      onFailure = mkForce [];
      serviceConfig = {
        ExecStart = "${sendmail} ${config.systemd.email-notify.mailTo} %i";
        Type = "oneshot";
      };
    };
  };
}
