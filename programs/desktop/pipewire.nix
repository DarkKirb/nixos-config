{ config, ... }:
{
  security.rtkit.enable = true;
  services.pipewire = {
    enable = config.isGraphical;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
}
