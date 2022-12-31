{pkgs, ...}: {
  environment.systemPackages = [ pkgs.cifs-utils pkgs.lxqt.lxqt-policykit ];
  networking.firewall.extraCommands = ''iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns'';
  services.gvfs.enable = true;
}
