{ pkgs, ... }:
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
    mplus-outline-fonts
    dina-font
    proggyfonts
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" "Noto" ]; })
    (import ../packages/linja-sike.nix pkgs)
  ];

  zramSwap = {
    enable = true;
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
        extraPkgs = pkgs: with pkgs; [
          mono
        ];
        nativeOnly = true;
      };
    })
  ];
  nixpkgs.config.allowBroken = true;
}
