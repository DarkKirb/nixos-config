{
  nix-flatpak,
  system,
  lib,
  ...
}:
{
  imports = [
    nix-flatpak.homeManagerModules.nix-flatpak
  ];

  services.flatpak = {
    packages = lib.mkMerge [
      (lib.mkIf (system == "x86_64-linux") [
        "dev.bambosh.UnofficialHomestuckCollection"
      ])
    ];
    remotes = [
      {
        name = "flathub";
        location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      }
    ];
  };

  home.persistence.default.directories = [
    ".local/share/flatpak"
    ".var"
  ];
}
