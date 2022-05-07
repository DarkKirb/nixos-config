{ config, ... }: {
  imports = [
    ../../modules/hostapd.nix
  ];
  services.hostapd = {
    enable = true;
    countryCode = "DE";
    interface = "wlp6s0";
    ssid = "racc";
    wpa = true;
    wpaPassphraseFile = config.sops.secrets."services/hostapd".path;
  };
  sops.secrets."services/hostapd" = {
    restartUnits = [
      "hostapd.service"
    ];
  };
}
