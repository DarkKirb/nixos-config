{pkgs, ...}: {
  output.path.path = with pkgs; [wl-clipboard xclip];
  isDesktop = true;
  output.extraConfig = ''
    " Clipboard settings, always use clipboard for all delete, yank, change, put
    " operation, see https://stackoverflow.com/q/30691466/6064933
    if !empty(provider#clipboard#Executable())
      set clipboard+=unnamedplus
    endif
  '';
}
