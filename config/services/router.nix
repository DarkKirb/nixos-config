{
  nixos-config-for-netboot,
  pkgs,
  ...
}: let
  netboot-x86_64 = pkgs.symlinkJoin {
    name = "netboot-x86_64";
    paths = [
      pkgs.ipxe
      nixos-config-for-netboot.nixosConfigurations.netboot.system.build.kernel
      nixos-config-for-netboot.nixosConfigurations.netboot.system.build.netbootRamdisk
      nixos-config-for-netboot.nixosConfigurations.netboot.system.build.netbootIpxeScript
    ];
  };
  bootIpxeScript = pkgs.writeText "boot.ipxe" ''
    chain http://192.168.2.1/${"$"}{buildarch}/netboot.ipxe
  '';
  netboot = pkgs.stdenvNoCC.mkDerivation {
    name = "netboot";
    src = pkgs.emptyDirectory;
    buildPhase = true;
    installPhase = ''
      mkdir $out
      cp ${bootIpxeScript} $out/boot.ipxe
      ln -svf ${netboot-x86_64} $out/x86_64
    '';
  };
in {
  networking.dhcpcd.allowInterfaces = ["enp2s0f0u4"]; # yes a usb network card don’t judge
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
        filename "http://192.168.2.1/boot.ipxe";
      } elsif substring (option vendor-class-identifier, 0, 10) = "HTTPClient" {
        filename "http://192.168.2.1/x86_64/ipxe.efi";
      } elsif option client-arch != 00:00 {
        filename "/ipxe.efi";
        next-server 192.168.2.1;
      } else {
        filename "/undionly.kpxe";
        next-server 192.168.2.1;
      }
    '';
    interfaces = ["br0"];
  };
  services.tftpd = {
    enable = true;
    path = pkgs.ipxe;
  };
  services.caddy.virtualHosts."http://192.168.2.1".extraConfig = ''
    import baseConfig
    root * ${netboot}
    file_server
  '';
  networking.firewall.interfaces."br0".allowedUDPPorts = [69 4011];
  # No i don’t have ipv6 :(
  networking.firewall.extraCommands = ''
    iptables -A FORWARD -i br0 -j ACCEPT
    iptables -t nat -A POSTROUTING -o enp2s0f0u4 -s 192.168.2.0/24 -j MASQUERADE
  '';
  networking.interfaces.enp1s0f0u4.macAddress = "00:d8:61:d0:de:1e"; # fucking ISP
  boot.kernel.sysctl = {
    "net.ipv4.conf.all.forwarding" = true;
    "net.ipv6.conf.all.forwarding" = true;
  };
}
