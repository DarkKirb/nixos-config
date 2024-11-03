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
    sopsFile = ./password.yaml;
  };
  home-manager.users.root = {config, ...}: {
    home.persistence."/persistent/${config.home.username}" = {
      files = [
        ".bash_history"
      ];
    };
  };
  environment.impermanence.users = ["root"];
}
