{...}: {
  services.openssh.enable = true;
  services.openssh.settings = {
    PermitRootLogin = true;
    PasswordAuthentication = false;
  };
  networking.firewall.allowedTCPPorts = [22];
}
