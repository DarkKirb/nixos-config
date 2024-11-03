{...}: {
  imports = [
    ./tide.nix
    ./z.nix
  ];
  programs.fish = {
    enable = true;
  };
  home.persistence.default.files = [
    ".local/share/fish/fish_history"
  ];
}
