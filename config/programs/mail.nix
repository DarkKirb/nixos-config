{
  programs.thunderbird = {
    enable = true;
    profiles.main = {
      withExternalGnupg = true;
      isDefault = true;
    };
  };
}
