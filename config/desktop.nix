{ config, pkgs, ... } @ args:
let
  lockscreen-all = pkgs.writeScript "lockscreen-all" ''
    #!${pkgs.bash}/bin/bash

    if ${pkgs.coreutils}/bin/[ -z "$(${pkgs.usbutils}/bin/lsusb | grep Yubico)" ]; then
      ${pkgs.systemd}/bin/loginctl list-sessions | ${pkgs.gnugrep}/bin/grep '^\ ' | ${pkgs.gawk}/bin/awk '{print $1}' | ${pkgs.findutils}/bin/xargs -i ${pkgs.systemd}/bin/loginctl lock-session {}
    fi
  '';
in
{
  imports = [
    ./services/sway.nix
    ./services/pipewire.nix
  ];
  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" "Noto" ]; })
    (import ../packages/linja-sike.nix pkgs)
  ];


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
        extraPkgs = pkgs: with pkgs; [
          mono
        ];
      };
    })
  ];
  programs.java.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;
  home-manager.users.darkkirb = import ./home-manager/darkkirb.nix { desktop = true; inherit args; };

  i18n.inputMethod = {
    enabled = "ibus";
    ibus.engines = with pkgs.ibus-engines; [
      mozc
      table
      table-others
      uniemoji
    ];
  };
  # For syncthing
  networking.firewall.allowedTCPPorts = [ 22000 ];
  networking.firewall.allowedUDPPorts = [ 22000 ];
}
