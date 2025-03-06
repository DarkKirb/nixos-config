{ config, ... }:
{
  security.rtkit.enable = true;
  services.pipewire = {
    enable = config.system.isGraphical;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
}
