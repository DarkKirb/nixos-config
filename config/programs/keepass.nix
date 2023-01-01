{
  pkgs,
  lib,
  ...
}: {
  home.packages = [pkgs.keepassxc];
  systemd.user.services.keepassxc = {
    Unit = {
      Description = "keepassxc";
    };
    Service = {
      ExecStart = "${pkgs.keepassxc}/bin/keepassxc";
    };
  };
}
