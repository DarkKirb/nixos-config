{
  system,
  nix-packages,
  config,
  pkgs,
  lib,
  ...
} @ args: let
  lockscreen-all = pkgs.writeScript "lockscreen-all" ''
    #!${pkgs.bash}/bin/bash

    if ${pkgs.coreutils}/bin/[ -z "$(${pkgs.usbutils}/bin/lsusb | grep Yubico)" ]; then
      ${pkgs.systemd}/bin/loginctl list-sessions | ${pkgs.gnugrep}/bin/grep '^\ ' | ${pkgs.gawk}/bin/awk '{print $1}' | ${pkgs.findutils}/bin/xargs -i ${pkgs.systemd}/bin/loginctl lock-session {}
    fi
  '';
in {
  imports = [
    ./services/pipewire.nix
    ./desktop-secrets.nix
    ./services/cups.nix
    ./services/docker.nix
    ./services/cifs.nix
    ./services/kubo-local.nix
  ];
  fonts = {
    fontDir.enable = true;
    fontconfig = {
      enable = true;
      defaultFonts = {
        emoji = ["Noto Color Emoji"];
        monospace = ["Fira Code" "Font Awesome 5 Free"];
        sansSerif = ["Noto Sans" "Font Awesome 5 Free"];
        serif = ["Noto Serif" "Font Awesome 5 Free"];
      };
    };
    fonts = with pkgs; [
      fira-code
      fira-code-symbols
      font-awesome
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      noto-fonts-extra
      (nerdfonts.override {fonts = ["FiraCode" "DroidSansMono" "Noto"];})
      nasin-nanpa
      fairfax-hd
      (pkgs.stdenvNoCC.mkDerivation rec {
        pname = "zbalermorna";
        version = "920b28d798ae1c06885c674bbf02b08ffed12b2f";
        src = pkgs.fetchFromGitHub {
          owner = "jackhumbert";
          repo = pname;
          rev = version;
          sha256 = "00sl3f1x4frh166mq85lwl9v1f5r3ckkfg8id5fibafymick5vyp";
        };
        installPhase = ''
          mkdir -p $out/share/fonts
          cp -r $src/fonts/*.otf $out/share/fonts
        '';
      })
    ];
  };
  fonts.fontconfig.localConf = ''
    <?xml version="1.0"?>
    <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
    <fontconfig>
      <match target="scan">
        <test name="family">
          <string>Fairfax HD</string>
        </test>
        <edit name="spacing">
          <int>100</int>
        </edit>
      </match>
    </fontconfig>
  '';

  time.timeZone = "Etc/GMT-1"; # Confusing naming, it's 1 hour east of GMT
  services.pcscd.enable = true;

  security.pam = {
    services.login.u2fAuth = true;
    services.sddm.u2fAuth = true;
    services.swaylock.u2fAuth = true;
    u2f = {
      enable = true;
      control = "required";
    };
  };
  services.udev.extraRules = ''
    ACTION=="remove", ENV{ID_VENDOR_ID}=="1050", ENV{ID_MODEL_ID}=="0407", RUN+="${lockscreen-all}"
    ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="e621", ATTRS{idProduct}=="0000", TAG+="uaccess"
    ACTION=="add", SUBSYSTEM=="hidraw*", ATTRS{idVendor}=="e621", ATTRS{idProduct}=="0000", TAG+="uaccess"
    ACTION=="add", SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="0337", TAG+="uaccess"
    ACTION=="add", SUBSYSTEM=="hidraw*", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="0306", TAG+="uaccess"
    ACTION=="add", SUBSYSTEM=="hidraw*", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="0330", TAG+="uaccess"
    ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="0403", ATTRS={idProduct}=="6010", OWNER="user", MODE="0777", GROUP="dialout"
  '';
  services.udev.packages = [pkgs.dolphinEmuMaster];
  programs.steam.enable = system == "x86_64-linux";
  nixpkgs.overlays = [
    (curr: prev: {
      steam = prev.steam.override {
        extraPkgs = pkgs:
          with pkgs; [
            mono
            fuse
          ];
      };
    })
  ];
  services.flatpak.enable = true;
  programs.java.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = lib.mkForce (system == "x86_64-linux");
  home-manager.users.darkkirb = import ./home-manager/darkkirb.nix {
    desktop = true;
    inherit args;
  };

  # For syncthing
  networking.firewall.allowedTCPPorts = [22000];
  networking.firewall.allowedUDPPorts = [22000];

  environment.systemPackages = with pkgs; [
    pinentry-qt
    dolphinEmuMaster
    kitty.terminfo
  ];
  programs.gnupg.agent.pinentryFlavor = "qt";

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };
  programs.dconf.enable = true;
  services.xserver = {
    enable = true;
    libinput.enable = true;
    layout = "de";
    xkbVariant = "neo";
    displayManager.lightdm.enable = lib.mkForce false;
    extraLayouts.zlr = {
      description = "lojban layout";
      languages = ["jbo"];
      symbolsFile = ../extra/keyboard/symbols;
    };
  };
  boot.kernelPackages = pkgs.zfsUnstable.latestCompatibleLinuxPackages;
  i18n.inputMethod = {
    enabled = "ibus";
    ibus.engines = with pkgs.ibus-engines; [anthy];
  };
  security.polkit.enable = true;
  services.dbus.enable = true;
  services.dbus.packages = with pkgs; [dconf];
  # Futureproofing: on non-x86 machines, emulate x86
  boot.binfmt.emulatedSystems =
    if system != "x86_64-linux"
    then [
      "x86_64-linux"
      "i686-linux"
    ]
    else [];

  virtualisation = {
    waydroid.enable = true;
    lxd.enable = true;
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
}
