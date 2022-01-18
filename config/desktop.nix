{ pkgs, ... }: {
  imports = [
    ./services/sway.nix
  ];
  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts
    dina-font
    proggyfonts
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
  ];

  zramSwap = {
    enable = true;
  };
  

  time.timeZone = "Etc/GMT-1"; # Confusing naming, it's 1 hour east of GMT
}
