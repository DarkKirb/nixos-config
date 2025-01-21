{ ... }:
{
  home.persistence.default.directories = [
    {
      directory = ".local/share/Steam";
      method = "symlink";
    }
  ];
}
