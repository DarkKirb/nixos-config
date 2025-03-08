{ config, ... }:
{
  services.avahi = {
    enable = config.system.isGraphical;
    allowPointToPoint = true;
  };
}
