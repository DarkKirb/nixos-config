{
  nixos-config-for-netboot,
  pkgs,
  ...
}: let
  win11Iso = pkgs.stdenv.mkDerivation {
    name = "Win11_22H2_EnglishInternational_x64v2.iso";

    src = pkgs.emptyDirectory;

    buildPhase = ''
      echo "Manually add a win11.iso with the correct hash to your store"

      exit 1
    '';

    outputHash = "0dgv9vjv375d5jx80y67ljz5vvpnb0inmia0cifga1zlsp1sq9zz";
    outputHashMode = "flat";
    outputHashAlgo = "sha256";
  };
  win11IsoDir = pkgs.stdenv.mkDerivation {
    name = "win11";

    src = pkgs.emptyDirectory;

    buildPhase = "true";
    installPhase = ''
      mkdir $out
      ln -sv ${win11Iso} $out/win11.iso
    '';
  };
  bootIpxeX86Script = pkgs.writeTextDir "boot.ipxe" ''
    #!ipxe
    :start
    menu iPXE boot menu
    item --gap -- ------------------------- Operating systems ------------------------------
    item --key n linux (N)ixOS (netboot)
    item --key w windows (W)indows 11 (installer)
    item --gap -- ----------------------------- Utilities ----------------------------------
    item --key e ext (E)xit
    item --key s shell EFI (S)hell
    choose version && goto ${"$"}{version} || goto start

    :linux
    chain http://192.168.2.1/x86_64/netboot.ipxe

    :windows
    sanboot http://192.168.2.1/x86_64/win11.iso

    :shell
    chain http://192.168.2.1/x86_64/shell.efi

    :ext
    exit
  '';
  netboot-x86_64 = pkgs.symlinkJoin {
    name = "netboot-x86_64";
    paths = [
      pkgs.ipxe
      nixos-config-for-netboot.nixosConfigurations.netboot.config.system.build.kernel
      nixos-config-for-netboot.nixosConfigurations.netboot.config.system.build.netbootRamdisk
      nixos-config-for-netboot.nixosConfigurations.netboot.config.system.build.netbootIpxeScript
      pkgs.edk2-uefi-shell
      bootIpxeX86Script
      win11IsoDir
    ];
  };
  bootIpxeScript = pkgs.writeText "boot.ipxe" ''
    #!ipxe
    set arch ${"$"}{buildarch}
    iseq ${"$"}{arch} i386 && cpuid --ext 29 && set arch x86_64 ||

    chain http://192.168.2.1/${"$"}{arch}/boot.ipxe
  '';
  netboot = pkgs.stdenvNoCC.mkDerivation {
    name = "netboot";
    src = pkgs.emptyDirectory;
    buildPhase = "true";
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
        option vendor-class-identifier "HTTPClient";
        filename "http://192.168.2.1/x86_64/ipxe.efi";
      } elsif option client-arch != 00:00 {
        filename "ipxe.efi";
        next-server 192.168.2.1;
      } else {
        filename "undionly.kpxe";
        next-server 192.168.2.1;
      }
    '';
    interfaces = ["br0"];
  };
  services.atftpd = {
    enable = true;
    root = pkgs.ipxe;
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
  networking.interfaces.enp2s0f0u4.macAddress = "00:d8:61:d0:de:1e"; # fucking ISP
  boot.kernel.sysctl = {
    "net.ipv4.conf.all.forwarding" = true;
    "net.ipv6.conf.all.forwarding" = true;
  };
}
