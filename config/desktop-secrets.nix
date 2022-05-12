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
  ]);
}
