{pkgs, ...}: {
  home.packages = with pkgs; [
    telegram-desktop
  ];
  home.persistence.default.directories = [".local/share/TelegramDesktop"];
}
