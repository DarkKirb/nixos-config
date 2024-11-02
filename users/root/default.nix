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
  environment.persistence."/persistent" = {
    directories = ["/root/.cache/nix"]; # for sanity
    files = ["/root/.bash_history"];
  };
  home-manager.users.root = {};
  environment.impermanence.users = ["root"];
}
