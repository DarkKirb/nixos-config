{...}: {
  programs.fish.enable = true;
  home.persistence.default.files = [
    ".local/share/fish/fish_history"
  ];
}
