desktop: _: {
  programs = {
    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      enableSyntaxHighlighting = true;
      enableVteIntegration = desktop;
      autocd = true;
      loginExtra =
        if desktop
        then ''
          if [[ -z "$DISPLAY" ]] && [[ $(tty) = "/dev/tty1" ]]; then
            exec sway
          fi
        ''
        else "";
    };
  };
}
