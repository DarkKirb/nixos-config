{ pkgs, ... }:
let script = ''
  cd /root/nixos-config

  ${pkgs.gitMinimal}/bin/git checkout main 
  ${pkgs.gitMinimal}/bin/git fetch origin
  ${pkgs.gitMinimal}/bin/git reset --hard origin/main

  TOKEN="$(${pkgs.coreutils}/bin/cat /run/secrets/hydra/gitea_token)"

  deploy_finished() {
    MAIN_SHA=$(${pkgs.curl}/bin/curl -X GET \
      "https://git.chir.rs/api/v1/repos/darkkirb/nixos-config/branches/main?token=$TOKEN"
      -H "accept: application/json" | ${pkgs.jq}/bin/jq -r '.commit.id')
    STAGING_SHA=$(${pkgs.curl}/bin/curl -X GET \
      "https://git.chir.rs/api/v1/repos/darkkirb/nixos-config/branches/staging?token=$TOKEN"
      -H "accept: application/json" | ${pkgs.jq}/bin/jq -r '.commit.id')

    if [[ "$MAIN_SHA" == "$STAGING_SHA" ]]; then
      ${pkgs.coreutils}/bin/echo "No changes to deploy"
      return 0
    fi

    COMMIT_STATUS=$(${pkgs.curl}/bin/curl -X 'GET' \
      "https://git.chir.rs/api/v1/repos/darkkirb/nixos-config/commits/$MAIN_SHA/status?token=$TOKEN" \
      -H 'accept: application/json' | ${pkgs.jq}/bin/jq -r '.state')

    if [[ "$COMMIT_STATUS" != "success" ]]; then
      ${pkgs.coreutils}/bin/echo "Commit status is not success"
      return 0
    fi

    ${pkgs.gitMinimal}/bin/git push origin staging
  }

  deploy_finished

  ${pkgs.nixUnstable}/bin/nix flake update

  ${pkgs.gitMinimal}/bin/git commit -am "Automatic nixpkgs update"
  ${pkgs.gitMinimal}/bin/git push origin main
''; in
{
  systemd.services.autodeploy = {
    enable = true;
    description = "Automatically deploy updates";
    inherit script;
  };
  systemd.timers.autodeploy = {
    enable = true;
    description = "Automatically deploy updates";
    requires = [ "autodeploy.service" ];
    wantedBy = [ "multi-user.target" ];
    timerConfig = {
      OnUnitActiveSec = 3600;
      OnBootSec = 3600;
    };
  };
}
