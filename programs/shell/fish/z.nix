{pkgs, ...}: {
  programs.fish.plugins = with pkgs.fishPlugins; [
    {
      name = "z";
      src = z.src;
    }
  ];
  home.persistence.default.directories = [
    ".local/share/z"
  ];
}
