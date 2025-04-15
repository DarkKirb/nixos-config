{
  config,
  pkgs,
  lib,
  ...
}:
{
  time.timeZone = "Etc/GMT-1";
  system.isGraphical = true;
  imports = [
    ./kde
    ./documentation.nix
    ./graphical/fonts.nix
    ../services/security-key
  ];
  home-manager.users.darkkirb.imports =
    if (config.system.wm == "sway") then
      [
        ./sway
        ./graphical/gtk-fixes
      ]
    else
      [ ./graphical/gtk-fixes ];
  xdg.portal = {
    wlr.enable = (config.system.wm == "sway");
    extraPortals =
      with pkgs;
      (lib.mkIf (config.system.wm == "sway") [
        xdg-desktop-portal-gtk
        kdePackages.xdg-desktop-portal-kde
        xdg-desktop-portal-wlr
      ]);
    config.common.default = lib.mkIf (config.system.wm == "sway") "wlr";
  };
  security.pam.services.swaylock = { };
  services.xserver.enable = true;
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    wayland.compositor = if (config.system.wm == "sway") then "weston" else "kwin";
  };
  programs.sway.enable = (config.system.wm == "sway");
  # Mount /media
  fileSystems."/media" = {
    device = "jellyfin@nas.int.chir.rs:/media";
    fsType = "sshfs";
    options = [
      "nodev"
      "noatime"
      "allow_other"
      "IdentityFile=${config.sops.secrets.".ssh/builder_id_ed25519".path}"
    ];
  };
  security.pam.services.login = {
    u2fAuth = true;
    unixAuth = lib.mkForce false;
  };
  security.pam.services.kde = {
    u2fAuth = true;
    unixAuth = lib.mkForce false;
  };
  security.pam.services.swaylock = {
    u2fAuth = true;
    unixAuth = lib.mkForce false;
  };
  security.pam.u2f = {
    enable = true;
    settings = {
      origin = "pam://chir.rs";
      interactive = true;
      cue = true;
      authfile = config.sops.secrets."etc/u2f_mappings".path;
    };
  };
  sops.secrets."etc/u2f_mappings".sopsFile = ./graphical-secrets.yaml;
}
