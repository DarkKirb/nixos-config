{config, ...}: {
  users.users.darkkirb = {
    createHome = true;
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIDXQlfvRUm/z6eP1EjsajIbMibkq9n+ymlbBi7NFiOuaAAAABHNzaDo= ssh:"
    ];
    hashedPasswordFile = config.sops.secrets."users/users/darkkirb/hashedPassword".path;
    extraGroups = ["wheel"];
  };
  sops.secrets."users/users/darkkirb/hashedPassword" = {
    neededForUsers = true;
    sopsFile = ./password.yaml;
  };
  environment.impermanence.users = ["darkkirb"];
}
