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
  installBat = pkgs.writeText "install.bat" ''
    wpeinit
    ipconfig
    net use i: \\192.168.2.1\INSTALL /user:none none

    i:
    setup.exe /AddBootMgrLast
  '';
  winpeshlIni = pkgs.writeText "winpeshl.ini" ''
    [LaunchhApps]
    "install.bat"
  '';
  win11SetupDir = pkgs.stdenv.mkDerivation {
    name = "win11-boot";
    src = pkgs.emptyDirectory;
    nativeBuildInputs = [pkgs.p7zip];
    buildPhase = "";
    installPhase = ''
      mkdir $out
      cd $out
      7z x ${win11Iso} efi/microsoft/boot/bcd boot/fonts/segmono_boot.ttf boot/fonts/segoe_slboot.ttf boot/fonts/segoen_slboot.ttf boot/fonts/wgl4_boot.ttf boot/boot.sdi sources/boot.wim
      ln -sv ${installBat} install.bat
      ln -sv ${winpeshlIni} winpeshl.ini
    '';
  };
  win11IsoDir = pkgs.stdenv.mkDerivation {
    name = "win11";

    src = pkgs.emptyDirectory;

    buildPhase = "true";
    installPhase = ''
      mkdir $out
      ln -sv ${win11Iso} $out/win11.iso
      ln -sv ${win11SetupDir} $out/setup
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
    imgfree
    kernel http://192.168.2.1/x86_64/share/wimboot/wimboot.x86_64.efi gui
    initrd http://192.168.2.1/x86_64/setup/install.bat install.bat
    initrd http://192.168.2.1/x86_64/setup/winpeshl.ini winpeshl.ini
    initrd http://192.168.2.1/x86_64/setup/efi/microsoft/boot/bcd BCD
    initrd http://192.168.2.1/x86_64/setup/boot/fonts/segmono_boot.ttf segmono_boot.ttf
    initrd http://192.168.2.1/x86_64/setup/boot/fonts/segoe_slboot.ttf segoe_slboot.ttf
    initrd http://192.168.2.1/x86_64/setup/boot/fonts/segoen_slboot.ttf segoen_slboot.ttf
    initrd http://192.168.2.1/x86_64/setup/boot/fonts/wgl4_boot.ttf wgl4_boot.ttf
    initrd http://192.168.2.1/x86_64/setup/boot/boot.sdi boot.sdi
    initrd http://192.168.2.1/x86_64/setup/sources/boot.wim boot.wim
    boot

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
      pkgs.wimboot
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
  services.kea.dhcp4.settings = {
    interfaces-config = {
      interfaces = [
        "br0"
      ];
    };
    lease-database = {
      name = "/var/lib/kea/dhcp4.leases";
      persist = true;
      type = "memfile";
    };
    rebind-timer = 2000;
    renew-timer = 1000;
    subnet4 = [
      {
        pools = [
          {
            pool = "192.168.2.100 - 192.168.2.240";
          }
        ];
        subnet = "192.168.2.0/24";
        option-data = [
          {
            name = "routers";
            data = "192.168.2.1";
          }
          {
            name = "domain-name-servers";
            data = "1.1.1.1";
          }
        ];
      }
    ];
    valid-lifetime = 4000;
  };
  services.kea.dhcp4.enable = true;
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
  fileSystems."/mnt/win" = {
    device = "${win11Iso}";
    options = ["loop" "ro"];
  };
}
