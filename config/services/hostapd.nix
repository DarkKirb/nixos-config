{ config, ... }: {
  imports = [
    ../../modules/hostapd.nix
  ];
  services.hostapd = {
    enable = true;
    countryCode = "DE";
    interface = "wlp6s0";
    ssid = "🦝";
    wpa = true;
    wpaPassphraseFile = config.sops.secrets."services/hostapd".path;
    extraConfig = ''
      utf8_ssid=1
    '';
  };
  sops.secrets."services/hostapd" = {
    restartUnits = [
      "hostapd.service"
    ];
  };
}
