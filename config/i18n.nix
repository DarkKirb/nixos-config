{ pkgs, lib, ... }: {
  console = {
    packages = [
      pkgs.darkkirb.neo2-linux-console
    ];
    keyMap = "neo";
  };
  i18n = {
    extraLocaleSettings = {
      LC_TIME = "de_DE.UTF-8"; # None of that nonsense american formatting thank you
    };
  };
  # I do not know who the fuck decided this was a reasonable name for the time zone, but
  # this is 1 hour east of UTC (7°30′ E to 22°30′ E). It’s marked as mkDefault because the
  # base server config overrides this with UTC and my laptop may temporarily change time
  # zone by being located outside of that band
  time.timeZone = lib.mkDefault "Etc/GMT-1";
}
