{ ... }: {
  networking.dhcpcd.allowInterfaces = [ "enp1s0f0u4" ]; # yes a usb network card don’t judge
  services.dhcpd4 = {
    enable = true;
    extraConfig = ''
      option subnet-mask 255.255.255.0;
      option broadcast-address 192.168.2.255;
      option routers 192.168.2.1;
      option domain-name-servers 1.1.1.1;
      subnet 192.168.2.0 netmask 255.255.255.0 {
        range 192.168.2.100 192.168.2.200;
      }
    '';
    interfaces = [ "br0" ];
  };
  # No i don’t have ipv6 :(
  networking.firewall.extraCommands = ''
    iptables -A FORWARD -i br0 -j ACCEPT
    iptables -t nat -A POSTROUTING -o enp1s0f0u4 -s 192.168.2.0/24 -j MASQUERADE
  '';
  networking.interfaces.enp1s0f0u4.macAddress = "00:d8:61:d0:de:1e"; # fucking ISP
  boot.kernel.sysctl = {
    "net.ipv4.conf.all.forwarding" = true;
    "net.ipv6.conf.all.forwarding" = true;
  };
}
