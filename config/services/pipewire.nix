_: {
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
    {
      domain = "@audio";
      item = "memlock";
      type = "-";
      value = "unlimited";
    }
    {
      domain = "@audio";
      item = "rtprio";
      type = "-";
      value = "99";
    }
    {
      domain = "@audio";
      item = "nofile";
      type = "soft";
      value = "99999";
    }
    {
      domain = "@audio";
      item = "nofile";
      type = "hard";
      value = "99999";
    }
  ];
  services.pipewire.config.pipewire-pulse = {
    "pusle.rules" = [
      {
        matches = [
          {
            "application.process.binary" = ".Discord-wrapped";
          }
          {
            "application.process.binary" = "Discord";
          }
        ];
        actions = {
          update-props = {
            "pulse.min.quantum" = "8192/48000";
          };
        };
      }
    ];
  };
}
