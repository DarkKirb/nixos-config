{ ... }: {
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    jack.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
  };
  security.rtkit.enable = true;
  hardware.pulseaudio.enable = false;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };
  security.pam.loginLimits = [
    { domain = "@audio"; item = "memlock"; type = "-"; value = "unlimited"; }
    { domain = "@audio"; item = "rtprio"; type = "-"; value = "99"; }
    { domain = "@audio"; item = "nofile"; type = "soft"; value = "99999"; }
    { domain = "@audio"; item = "nofile"; type = "hard"; value = "99999"; }
  ];
  services.pipewire.config.pipewire."context.properties"."default.clock.rate" = 384000;
  services.pipewire.config.pipewire."context.properties"."default.clock.allowed-rates" = [
    44100
    48000
    88200
    96000
    176400
    192000
    352800
    384000
  ];
  services.pipewire.config.pipewire."context.properties"."default.clock.quantum" = 8192;
  services.pipewire.config.pipewire-pulse = {
    "pusle.rules" = [
      {
        matches = [{
          "application.process.binary" = ".Discord-wrapped";
        }];
        actions = {
          update-props = {
            "pulse.min.quantum" = "1024/48000";
          };
        };
      }
    ];
  };
}
