{...}: {
  services.openssh.enable = true;
  services.openssh.settings = {
    PermitRootLogin = "yes";
    PasswordAuthentication = false;
  };
  networking.firewall.allowedTCPPorts = [22];
}
