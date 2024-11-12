{ pkgs, ... }:
{
  home.file.widevine-lib.source = "${pkgs.widevine-cdm}/share/google/chrome/WidevineCdm/_platform_specific/linux_x64/libwidevinecdm.so";
  home.file.widevine-lib.target = ".kodi/cdm/libwidevinecdm.so";
  home.file.widevine-manifest.source = "${pkgs.widevine-cdm}/share/google/chrome/WidevineCdm/manifest.json";
  home.file.widevine-manifest.target = ".kodi/cdm/manifest.json";
  home.packages = [
    (pkgs.kodi.withPackages (
      kodiPkgs: with kodiPkgs; [
        jellyfin
        jellycon
        pkgs.kodi-joyn
      ]
    ))
  ];
  home.persistence.default.directories = [
    ".kodi/userdata"
  ];
}
