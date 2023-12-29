{pkgs, ...}: {
  programs.thunderbird = {
    package = pkgs.thunderbird-bin;
    enable = true;
    profiles.main = {
      withExternalGnupg = true;
      isDefault = true;
    };
  };
}
