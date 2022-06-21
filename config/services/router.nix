_: {
  networking.dhcpcd.allowInterfaces = ["enp1s0f0u4"]; # yes a usb network card don’t judge
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
      option client-arch code 93 = unsigned integer 16;
      if exists user-class and option user-class = "iPXE" {
        option root-path "iscsi:192.168.2.1:::1:iqn.2022-06.rs.chir:rs.chir.int.nas.windows";
        filename "http://192.168.2.1/boot.ipxe";
      } elsif option client-arch != 00:00 {
        filename "ipxe.efi";
      } else {
        filename "undionly.kpxe";
      }
      next-server 192.168.2.1;
    '';
    interfaces = ["br0"];
  };
  services.tftpd = {
    enable = true;
    path = ../../extra/tftp;
  };
  networking.firewall.interfaces."br0".allowedUDPPorts = [ 69 4011 ];
  services.nginx.virtualHosts."192.168.2.1" = {
    root = "/var/lib/netboot";
    forceSSL = false;
    rejectSSL = true;
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
