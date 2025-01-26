# Unlike other modules in this directory, this one is not enabled by default
# The default graphical configuration would enable this, the verbose configuration would not.
{ ... }:
{
  boot = {
    plymouth.enable = true;
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
    loader.timeout = 0;
    loader.systemd-boot.configurationLimit = 5; # Due to the plymouth theme containing the system background, it causes out of space errors on my 1GB boot partition
  };
}
