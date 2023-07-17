{
  prsJSON,
  nixpkgs,
}: let
  pkgs = import nixpkgs {};
  prs = builtins.fromJSON (builtins.readFile prsJSON);
  jobsets =
    (builtins.listToAttrs (
      map (
        info: {
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
              nixpkgs = {
                type = "git";
                value = "https://github.com/NixOS/nixpkgs.git master";
                emailresponsible = false;
              };
              gitea_status_repo = {
                type = "string";
                value = "nixos-config";
                emailresponsible = false;
              };
              gitea_repo_owner = {
                type = "string";
                value = "${info.head.repo.owner.login}";
                emailresponsible = false;
              };
              gitea_repo_name = {
                type = "string";
                value = "${info.head.repo.name}";
                emailresponsible = false;
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
        flake = "git+https://git.chir.rs/darkkirb/nixos-config.git?ref=main";
        checkinterval = 0;
        schedulingshares = 100;
        enableemail = false;
        emailoverride = "";
        keepnr = 1;
        inputs = {
          gitea_status_repo = {
            type = "string";
            value = "nixos-config";
            emailresponsible = false;
          };
          gitea_repo_owner = {
            type = "string";
            value = "darkkirb";
            emailresponsible = false;
          };
          gitea_repo_name = {
            type = "string";
            value = "nix-packages";
            emailresponsible = false;
          };
        };
      };
    };
in {jobsets = pkgs.writeText "jobsets.json" (builtins.toJSON jobsets);}
