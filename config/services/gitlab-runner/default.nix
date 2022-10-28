{
  services.gitlab-runner = {
    enable = true;
    services = {
      hsmw = {
        registrationConfigFile = toString ./hsmw.conf;
        dockerImage = "alpine";
      };
    };
  };
}
