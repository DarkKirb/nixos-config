{ ... }: {
  services.fail2ban = {
    enable = true;
    bantime-increment.enable = true;
    bantime-increment.maxtime = "48h";
  };
}
