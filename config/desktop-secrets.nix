{ ... }:
let mkSopsSecret =
  { name
  , path
  }: {
    name = "desktop/${name}";
    value = {
      sopsFile = ../secrets/desktop.yaml;
      owner = "darkkirb";
      key = name;
      path = "/home/darkkirb/${path}";
    };
  };
in
{
  sops.secrets = builtins.listToAttrs (map mkSopsSecret [
    {
      name = "aws/credentials";
      path = ".aws/credentials";
    }
    {
      name = ".config/gh/hosts.yml";
      path = ".config/gh/hosts.yml";
    }
    {
      name = ".config/github-copilot/hosts.json";
      path = ".config/github-copilot/hosts.json";
    }
  ]);
}
