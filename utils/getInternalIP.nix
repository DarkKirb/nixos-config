config: let
  removeCIDR = cidr: builtins.elemAt (builtins.split "/" cidr) 0;
  filterIPsBare = builtins.map removeCIDR;
  filterIPs = builtins.map (f: "[${removeCIDR f}]");
in rec {
  listenIPs = filterIPs config.networking.wireguard.interfaces."wg0".ips;
  listenIPsBare = filterIPsBare config.networking.wireguard.interfaces."wg0".ips;
  listenIP = builtins.elemAt listenIPs 0;
}
