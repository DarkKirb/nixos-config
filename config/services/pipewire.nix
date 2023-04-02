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
  environment.etc."pipewire/pipewire-pulse.conf.d/discord.conf".text = ''
    pulse.rules = [
      {
        # Discord notification sounds fix
        matches = [
          { application.process.binary = "Discord" }
          { application.process.binary = ".Discord-wrapped" }
        ]
        actions = {
            update-props = {
                pulse.min.quantum      = 1024/48000     # 21ms
            }
        }
      }
    ]
  '';
}
