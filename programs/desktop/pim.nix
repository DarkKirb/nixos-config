{ pkgs, ... }:
{
  home.packages = with pkgs.kdePackages; [
    kontact
    kmail-account-wizard
    kdepim-runtime
    kdepim-addons
  ];
  home.persistence.default.directories = [
    ".local/share/akonadi"
    ".local/share/kontact"
    ".local/share/akonadi_maildir_resource_0"
    ".local/share/akgregator"
  ];
}
