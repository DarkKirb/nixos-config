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
  environment.systemPackages = [ pkgs.rclone ];
  environment.etc."rclone-mnt.conf".text = ''
    [jellyfin]
    type = sftp
    shell_type = unix
    key_file = ${config.sops.secrets.".ssh/builder_id_ed25519".path}
    host = nas.int.chir.rs
    user = jellyfin
    md5sum_command = md5sum
    sha1sum_command = sha1sum
  '';
  fileSystems."/media" = {
    device = "jellyfin:/media";
    fsType = "rclone";
    options = [
      "nodev"
      "nofail"
      "allow_other"
      "args2env"
      "config=/etc/rclone-mnt.conf"
      "vfs-cache-mode=full"
      "cache-dir=/var/cache/media-mnt"
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
  sops.secrets."etc/u2f_mappings" = {
    sopsFile = ./graphical-secrets.yaml;
    mode = "0440";
    group = "users";
  };
}
