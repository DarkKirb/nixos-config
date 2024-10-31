{...}: {
  services.openssh.enable = true;
  services.openssh.settings = {
    PermitRootLogin = true;
    PasswordAuthentication = "no";
  };
  networking.firewall.allowedTCPPorts = [22];
}
