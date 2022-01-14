{ ... }: {
  services.prometheus = {
    enable = true;
    port = 9001;
  };
}
