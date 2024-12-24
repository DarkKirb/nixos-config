{ config, ... }: {
  services.avahi = {
    enable = config.isGraphical;
    allowPointToPoint = true;
  };
}
