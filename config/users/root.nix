{config, ...}: {
  users.users.root = {
    openssh.authorizedKeys.keys = [
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIDXQlfvRUm/z6eP1EjsajIbMibkq9n+ymlbBi7NFiOuaAAAABHNzaDo= ssh:"
    ];
    passwordFile = config.sops.secrets."password/root".path;
  };
  sops.secrets."password/root" = {
    neededForUsers = true;
  };
}
