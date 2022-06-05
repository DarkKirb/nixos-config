{ ... }: {
  services.github-runner = {
    enable = true;
    url = "https://github.com/DarkKirb";
    tokenFile = "/run/secrets/github-runner/nixos.token";
  };
}
