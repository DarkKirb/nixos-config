config:
let
  removeCIDR = cidr: builtins.elemAt (builtins.split "/" cidr) 0;
  filterIPsBare = cidrs: builtins.map removeCIDR cidrs;
  filterIPs = cidrs: builtins.map (f: "[${removeCIDR f}]") cidrs;
in
rec {
  listenIPs = filterIPs config.networking.wireguard.interfaces."wg0".ips;
  listenIPsBare = filterIPsBare config.networking.wireguard.interfaces."wg0".ips;
  listenIP = builtins.elemAt listenIPs 0;
}
