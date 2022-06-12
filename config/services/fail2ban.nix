_: {
  services.fail2ban = {
    enable = true;
    bantime-increment.enable = true;
    bantime-increment.maxtime = "48h";
    jails = {
      dovecot = ''
        enabled = true
        filter   = dovecot
        action   = iptables-multiport[name=dovecot, port="pop3,pop3s,imap,imaps", protocol=tcp]
      '';
      postfix = ''
        enabled = true
        filter   = postfix
        action   = iptables-multiport[name=postfix, port="imap,imaps,submission", protocol=tcp]
      '';
    };
  };
}
