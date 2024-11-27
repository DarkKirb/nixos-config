{ pkgs, ... }:
{
  fonts = {
    fontDir.enable = true;
    fontconfig = {
      enable = true;
      defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
        monospace = [
          "Fira Code"
          "Font Awesome 5 Free"
        ];
        sansSerif = [
          "Noto Sans"
          "Font Awesome 5 Free"
        ];
        serif = [
          "Noto Serif"
          "Font Awesome 5 Free"
        ];
      };
    };
    packages = with pkgs; [
      fira-code
      fira-code-symbols
      font-awesome
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      noto-fonts-extra
      nerd-fonts.fira-mono
      nerd-fonts.fira-code
      nerd-fonts.droid-sans-mono
      nerd-fonts.noto
    ];
  };
}
