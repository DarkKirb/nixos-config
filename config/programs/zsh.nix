desktop: _: {
  programs = {
    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      enableVteIntegration = desktop;
      autocd = true;
    };
  };
}
