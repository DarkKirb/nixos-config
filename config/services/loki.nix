_: {
  services.loki = {
    enable = true;
    configFile = ./loki.yaml;
  };
}
