{
  services.gitlab-runner = {
    enable = true;
    services = {
      hsmw = {
        registrationConfigFile = ./hsmw.conf;
      };
    };
  };
}
