{
  services.gitlab-runner = {
    enable = true;
    services = {
      hsmw = {
        registrationConfigFile = toString ./hsmw.conf;
        dockerImage = "alpine";
      };
      hsmw-fork = {
        registrationConfigFile = toString ./hsmw-fork.conf;
        dockerImage = "alpine";
      };
    };
  };
}
