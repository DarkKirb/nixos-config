{ dns, ksk, zsk, zone, zonename, ... }: { pkgs, system, ... }:
let
  writeZone = dns.util.${system}.writeZone;
  zoneFile = writeZone zonename zone;
in
{
  systemd.services."zonesign@${zonename}" = {
    description = "Signing the DNS zone '${zonename}'";
    wantedBy = [ "bind.service" ];
    before = [ "bind.service" ];
    script = ''
      set -ex

      # Create the named directory if it doesn’t exist
      ${pkgs.coreutils}/bin/mkdir -pv /var/lib/named

      # Sign the zone and write it to /var/lib/named
      ${pkgs.bind}/bin/dnssec-signzone -o ${zonename} -k /run/secrets/${ksk} -a -3 $(${pkgs.coreutils}/bin/head -c 16 /dev/urandom | ${pkgs.coreutils}/bin/sha256sum | ${pkgs.coreutils}/bin/cut -b 1-32) -f /var/lib/named/${zonename} ${zoneFile} /run/secrets/${zsk}
      ${pkgs.bind}/bin/rndc reload ${zonename} || true
    '';
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
  sops.secrets."${ksk}.key" = { };
  sops.secrets."${ksk}.private" = { };
  sops.secrets."${zsk}.key" = { };
  sops.secrets."${zsk}.private" = { };
}
