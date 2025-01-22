{
  dns,
  ksk,
  zsk,
  zone,
  zonename,
  ...
}:
{
  pkgs,
  system,
  lib,
  ...
}:
let
  inherit (dns.util.${system}) writeZone;
  zoneFile = writeZone zonename zone;
in
{
  systemd.services."zonesign@${zonename}" = {
    description = "Signing the DNS zone '${zonename}'";
    wantedBy = [ "bind.service" ];
    before = [ "bind.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "yes";
    };
    script = ''
      set -ex

      # Create the named directory if it doesn’t exist
      ${lib.getExe' pkgs.coreutils "mkdir"} -pv /var/lib/named

      # Sign the zone and write it to /var/lib/named
      ${lib.getExe' pkgs.bind "dnssec-signzone"} -N unixtime -o ${zonename} -k /run/secrets/${ksk} -a -3 $(${lib.getExe' pkgs.coreutils "head"} -c 16 /dev/urandom | ${lib.getExe' pkgs.coreutils "sha256sum"} | ${lib.getExe' pkgs.coreutils "cut"} -b 1-32) -f /var/lib/named/${zonename} ${zoneFile} /run/secrets/${zsk}
      ${lib.getExe' pkgs.systemd "systemctl"} reload bind || true
    '';
    restartIfChanged = true;
  };
  systemd.timers."zonesign@${zonename}" = {
    description = "Resign the DNS zone '${zonename}'";
    timerConfig = {
      Unit = "zonesign@${zonename}.service";
      OnUnitInactiveSec = 86400;
      RandomizedDelaySec = 3600;
    };
    wantedBy = [ "bind.service" ];
  };
  sops.secrets."${ksk}.key".sopsFile = ./secrets.yaml;
  sops.secrets."${ksk}.private".sopsFile = ./secrets.yaml;
  sops.secrets."${zsk}.key".sopsFile = ./secrets.yaml;
  sops.secrets."${zsk}.private".sopsFile = ./secrets.yaml;
}
