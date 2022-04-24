{ config, lib, pkgs, utils, ... }:

# TODO:
#
# asserts
#   ensure that the nl80211 module is loaded/compiled in the kernel
#   wpa_supplicant and hostapd on the same wireless interface doesn't make any sense

with lib;

let

  cfg = config.services.hostapd;

  escapedInterface = utils.escapeSystemdPath cfg.interface;

  configFile = pkgs.writeText "hostapd.conf" ''
    interface=${cfg.interface}
    driver=${cfg.driver}
    ssid=${cfg.ssid}
    hw_mode=${cfg.hwMode}
    channel=${toString cfg.channel}
    ${optionalString (cfg.countryCode != null) "country_code=${cfg.countryCode}"}
    ${optionalString (cfg.countryCode != null) "ieee80211d=1"}

    # logging (debug level)
    logger_syslog=-1
    logger_syslog_level=${toString cfg.logLevel}
    logger_stdout=-1
    logger_stdout_level=${toString cfg.logLevel}

    ctrl_interface=/run/hostapd
    ctrl_interface_group=${cfg.group}

    ${optionalString cfg.wpa ''
      wpa=2
      wpa_passphrase=${if cfg.wpaPassphrase != null then cfg.wpaPassphrase else "#WPA_PASSPHRASE#"}
    ''}
    ${optionalString cfg.noScan "noscan=1"}

    ${cfg.extraConfig}
  '';

in

{
  ###### interface

  options = {

    services.hostapd = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable putting a wireless interface into infrastructure mode,
          allowing other wireless devices to associate with the wireless
          interface and do wireless networking. A simple access point will
          <option>enable hostapd.wpa</option>,
          <option>hostapd.wpaPassphrase</option>, and
          <option>hostapd.ssid</option>, as well as DHCP on the wireless
          interface to provide IP addresses to the associated stations, and
          NAT (from the wireless interface to an upstream interface).
        '';
      };

      interface = mkOption {
        default = "";
        example = "wlp2s0";
        type = types.str;
        description = ''
          The interfaces <command>hostapd</command> will use.
        '';
      };

      noScan = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Do not scan for overlapping BSSs in HT40+/- mode.
          Caution: turning this on will violate regulatory requirements!
        '';
      };

      driver = mkOption {
        default = "nl80211";
        example = "hostapd";
        type = types.str;
        description = ''
          Which driver <command>hostapd</command> will use.
          Most applications will probably use the default.
        '';
      };

      ssid = mkOption {
        default = "nixos";
        example = "mySpecialSSID";
        type = types.str;
        description = "SSID to be used in IEEE 802.11 management frames.";
      };

      hwMode = mkOption {
        default = "g";
        type = types.enum [ "a" "b" "g" ];
        description = ''
          Operation mode.
          (a = IEEE 802.11a, b = IEEE 802.11b, g = IEEE 802.11g).
        '';
      };

      channel = mkOption {
        default = 7;
        example = 11;
        type = types.int;
        description = ''
          Channel number (IEEE 802.11)
          Please note that some drivers do not use this value from
          <command>hostapd</command> and the channel will need to be configured
          separately with <command>iwconfig</command>.
        '';
      };

      group = mkOption {
        default = "wheel";
        example = "network";
        type = types.str;
        description = ''
          Members of this group can control <command>hostapd</command>.
        '';
      };

      wpa = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Enable WPA (IEEE 802.11i/D3.0) to authenticate with the access point.
        '';
      };

      wpaPassphrase = mkOption {
        default = null;
        example = "any_64_char_string";
        type = types.nullOr types.str;
        description = ''
          WPA-PSK (pre-shared-key) passphrase. Clients will need this
          passphrase to associate with this access point.
          Warning: This passphrase will get put into a world-readable file in
          the Nix store!
        '';
      };

      wpaPassphraseFile = mkOption {
        default = null;
        example = "/run/secrets/wpa_passphrase";
        type = types.nullOr types.str;
        description = ''
          File containing WPA-PSK passphrase. Clients will need this
          passphrase to associate with this access point.
        '';
      };

      logLevel = mkOption {
        default = 2;
        type = types.int;
        description = ''
          Levels (minimum value for logged events):
          0 = verbose debugging
          1 = debugging
          2 = informational messages
          3 = notification
          4 = warning
        '';
      };

      countryCode = mkOption {
        default = null;
        example = "US";
        type = with types; nullOr str;
        description = ''
          Country code (ISO/IEC 3166-1). Used to set regulatory domain.
          Set as needed to indicate country in which device is operating.
          This can limit available channels and transmit power.
          These two octets are used as the first two octets of the Country String
          (dot11CountryString).
          If set this enables IEEE 802.11d. This advertises the countryCode and
          the set of allowed channels and transmit power levels based on the
          regulatory limits.
        '';
      };

      extraConfig = mkOption {
        default = "";
        example = ''
          auth_algo=0
          ieee80211n=1
          ht_capab=[HT40-][SHORT-GI-40][DSSS_CCK-40]
        '';
        type = types.lines;
        description = "Extra configuration options to put in hostapd.conf.";
      };
    };
  };

  disabledModules = [ "services/networking/hostapd.nix" ];

  ###### implementation

  config = mkIf cfg.enable {

    assertions = [
      {
        assertion = cfg.wpa != null -> (cfg.wpaPassphrase != null || cfg.wpaPassphraseFile != null);
        message = "Either wpaPassphrase or wpaPassphraseFile must be set if wpa is enabled.";
      }
      {
        assertion = cfg.wpaPassphraseFile != null -> cfg.wpaPassphrase == null;
        message = "You cannot provide a wpaPassphrase and a wpaPassphraseFile!";
      }
    ];

    environment.systemPackages = [ pkgs.hostapd ];

    services.udev.packages = optional (cfg.countryCode != null) [ pkgs.crda ];

    systemd.services.hostapd =
      {
        description = "hostapd wireless AP";

        path = [ pkgs.hostapd ];
        after = [ "sys-subsystem-net-devices-${escapedInterface}.device" ];
        bindsTo = [ "sys-subsystem-net-devices-${escapedInterface}.device" ];
        requiredBy = [ "network-link-${cfg.interface}.service" ];
        wantedBy = [ "multi-user.target" ];

        preStart = mkIf (cfg.wpaPassphraseFile != null) ''
          PASSPHRASE=$(cat ${cfg.wpaPassphraseFile})
          sed 's|#WPA_PASSPHRASE#|$PASSPHRASE|g' ${configFile} > /run/hostapd/hostapd.conf
        '';

        serviceConfig =
          {
            ExecStart = "${pkgs.hostapd}/bin/hostapd ${if cfg.wpaPassphraseFile != null then "/run/hostapd/hostapd.conf" else configFile}";
            Restart = "always";
          };
      };
    systemd.tmpfiles.rules = mkIf (cfg.wpaPassphraseFile != null) [
      "d '/run/hostapd' 0700 root root - -"
    ];
  };
}
