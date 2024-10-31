{...}: {
  services.openssh.enable = true;
  services.openssh.settings = {
    PermitRootLogin = "prohibit-password";
    PasswordAuthentication = false;
  };
  networking.firewall.allowedTCPPorts = [22];
}
