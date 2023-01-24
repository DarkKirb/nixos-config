{
  prsJSON,
  nixpkgs,
}: let
  pkgs = import nixpkgs {};
  prs = builtins.fromJSON (builtins.readFile prsJSON);

  jobsets =
    (pkgs.lib.mapAttrs (
        num: info: {
          enabled = 1;
          hidden = false;
          description = "PR ${num}: ${info.title}";
          nixexprinput = "nixos-config";
          nixexprpath = "hydra/default.nix";
          checkinterval = 300;
          schedulingshares = 100;
          enableemail = false;
          emailoverride = "";
          keepnr = 1;
          inputs = {
            nixos-config = {
              type = "git";
              value = "https://github.com/${info.head.repo.owner.login}/${info.head.repo.name}.git ${info.head.ref}";
              emailresponsible = false;
            };
          };
        }
      )
      prs)
    // {
      nixos-config = {
        enabled = 1;
        hidden = false;
        description = "Current nixos config";
        nixexprinput = "nixos-config";
        nixexprpath = "hydra/default.nix";
        checkinterval = 300;
        schedulingshares = 100;
        enableemail = false;
        emailoverride = "";
        keepnr = 1;
        inputs = {
          nixos-config = {
            type = "git";
            value = "https://github.com/DarkKirb/nixos-config.git main";
            emailresponsible = false;
          };
        };
      };
    };
in {jobsets = pkgs.writeText "jobsets.json" (builtins.toJSON jobsets);}
