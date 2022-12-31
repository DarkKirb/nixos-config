{
  system,
  nix-packages,
  config,
  pkgs,
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
  ];
  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    (nerdfonts.override {fonts = ["FiraCode" "DroidSansMono" "Noto"];})
    nix-packages.packages.${system}.nasin-nanpa
    nix-packages.packages.${system}.fairfax-hd
  ];
  fonts.fontconfig.enable = true;
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
    SUBSYSTEM=="usb", ATTRS{idVendor}=="e621", ATTRS{idProduct}=="0000", TAG+="uaccess"
    SUBSYSTEM=="hidraw*", ATTRS{idVendor}=="e621", ATTRS{idProduct}=="0000", TAG+="uaccess"
    SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="0337", TAG+="uaccess"
    SUBSYSTEM=="hidraw*", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="0306", TAG+="uaccess"
    SUBSYSTEM=="hidraw*", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="0330", TAG+="uaccess"
  '';
  programs.steam.enable = true;
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
  hardware.opengl.driSupport32Bit = true;
  home-manager.users.darkkirb = import ./home-manager/darkkirb.nix {
    desktop = true;
    inherit args;
  };

  # For syncthing
  networking.firewall.allowedTCPPorts = [22000];
  networking.firewall.allowedUDPPorts = [22000];

  environment.systemPackages = with pkgs; [
    pinentry-gtk2
  ];
  programs.gnupg.agent.pinentryFlavor = "gtk2";

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };
  programs.dconf.enable = true;
  services.xserver = {
    enable = true;
    displayManager.defaultSession = "sway";
    displayManager.sddm.enable = true;
    libinput.enable = true;
    layout = "de";
    xkbVariant = "neo";
  };
  programs.sway.enable = true;
  boot.kernelPackages = pkgs.zfsUnstable.latestCompatibleLinuxPackages;
  i18n.inputMethod = {
    enabled = "ibus";
    ibus.engines = with pkgs.ibus-engines; [anthy];
  };
}
