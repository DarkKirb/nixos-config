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

  environment.sessionVariables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    GLFW_IM_MODULE = "fcitx";
  };

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
  '';
  programs.steam.enable = true;
  nixpkgs.overlays = [
    (curr: prev: {
      steam = prev.steam.override {
        extraPkgs = pkgs:
          with pkgs; [
            mono
          ];
      };
    })
  ];
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

  environment.systemPackages = [
    pkgs.qt5.qtwayland
  ];

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    gtkUsePortal = true;
  };
}
