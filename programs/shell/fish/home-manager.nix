{pkgs, ...}: {
  programs.fish = {
    enable = true;
    plugins = with pkgs.fishPlugins; [
      {
        name = "tide";
        src = tide.src;
      }
    ];
  };
  home.persistence.default.files = [
    ".local/share/fish/fish_history"
  ];
}
