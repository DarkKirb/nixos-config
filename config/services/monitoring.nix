{pkgs, ...}: {
  imports = [../../modules/systemd-email-notify.nix];
  programs.msmtp = {
    enable = true;
    accounts = {
      default = {
        auth = true;
        tls = true;
        host = "mail.chir.rs";
        from = "notification@chir.rs";
        user = "lotte@chir.rs";
        passwordeval = "cat /run/secrets/email/lotte@chir.rs";
      };
    };
  };
  systemd.email-notify.mailFrom = "notif@chir.rs";
  systemd.email-notify.mailTo = "lotte@chir.rs";
}
