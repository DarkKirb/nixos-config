{
  prsJSON,
  nixpkgs,
}: let
  pkgs = import nixpkgs {};
  prs = builtins.fromJSON (builtins.readFile prsJSON);
  jobsets =
    (builtins.listToAttrs (
      pkgs.lib.attrsets.mapAttrsToList (
        _: info: {
          name = "pr${toString info.number}";
          value = {
            enabled = info.state == "open";
            hidden = info.state != "open";
            description = "PR ${toString info.number}: ${info.title}";
            nixexprinput = "nixos-config";
            nixexprpath = "hydra/default.nix";
            checkinterval = 3600;
            schedulingshares = 100;
            enableemail = false;
            emailoverride = "";
            keepnr = 1;
            inputs = {
              nixos-config = {
                type = "git";
                value = "${info.head.repo.clone_url} ${info.head.ref}";
                emailresponsible = false;
              };
              gitea_status_repo = {
                type = "string";
                value = "nixos-config";
              };
              gitea_repo_owner = {
                type = "string";
                value = info.head.repo.owner.login;
              };
              gitea_repo_name = {
                type = "string";
                value = info.head.repo.name;
              };
            };
          };
        }
      )
      prs
    ))
    // {
      nixos-config = {
        enabled = 1;
        hidden = false;
        description = "Current nixos config";
        nixexprinput = "nixos-config";
        nixexprpath = "hydra/default.nix";
        checkinterval = 0;
        schedulingshares = 100;
        enableemail = false;
        emailoverride = "";
        keepnr = 1;
        inputs = {
          nixos-config = {
            type = "git";
            value = "https://git.chir.rs/darkkirb/nixos-config main";
            emailresponsible = false;
          };
          gitea_status_repo = {
            type = "string";
            value = "nixos-config";
          };
          gitea_repo_owner = {
            type = "string";
            value = "Darkkirb";
          };
          gitea_repo_name = {
            type = "string";
            value = "nixos-config";
          };
        };
      };
    };
in {jobsets = pkgs.writeText "jobsets.json" (builtins.toJSON jobsets);}
