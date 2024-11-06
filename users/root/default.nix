{config, ...}: {
  users.users.root = {
    createHome = true;
    openssh.authorizedKeys.keys = [
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIDXQlfvRUm/z6eP1EjsajIbMibkq9n+ymlbBi7NFiOuaAAAABHNzaDo= ssh:"
    ];
    hashedPasswordFile = config.sops.secrets."users/users/root/hashedPassword".path;
  };
  sops.secrets."users/users/root/hashedPassword" = {
    neededForUsers = true;
    sopsFile = ./system.yaml;
  };
  sops.secrets."users/users/root/age-key" = {
    owner = "root";
    sopsFile = ./system.yaml;
  };
  home-manager.users.root.sops.age.keyFile = config.sops.secrets."users/users/root/age-key".path;
  environment.impermanence.users = ["root"];
}
