{ ... }: {
  service.pipewire = {
    enable = true;
    pulse.enable = true;
    jack.enable = true;
    alsa.enable = true;
  };
  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };
}
