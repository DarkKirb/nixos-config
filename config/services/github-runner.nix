{config, ...}: {
  services.github-runner = {
    enable = true;
    url = "https://github.com/DarkKirb/nixos-config";
    tokenFile = config.sops.secrets."services/github-runner/nixos.token".path;
  };
  sops.secrets."services/github-runner/nixos.token" = {};
}
