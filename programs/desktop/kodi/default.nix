{ pkgs, system, ... }:
{
  home.file.widevine-lib.enable = system == "x86_64-linux";
  home.file.widevine-lib.source = "${pkgs.widevine-cdm}/share/google/chrome/WidevineCdm/_platform_specific/linux_x64/libwidevinecdm.so";
  home.file.widevine-lib.target = ".kodi/cdm/libwidevinecdm.so";
  home.file.widevine-manifest.enable = system == "x86_64-linux";
  home.file.widevine-manifest.source = "${pkgs.widevine-cdm}/share/google/chrome/WidevineCdm/manifest.json";
  home.file.widevine-manifest.target = ".kodi/cdm/manifest.json";
  home.packages = [
    (pkgs.kodi-wayland.withPackages (
      kodiPkgs: with kodiPkgs; [
        jellyfin
        jellycon
        pkgs.kodi-joyn
        youtube
        sendtokodi
        sponsorblock
        visualization-starburst
        mediathekview
      ]
    ))
  ];
  home.persistence.default.directories = [
    ".kodi/userdata"
  ];
}
