{
  system,
  nix-packages,
  lib,
  config,
  pkgs,
  ...
}: let
  inherit ((import ../../utils/getInternalIP.nix config)) listenIPs;
  listenStatements =
    lib.concatStringsSep "\n" (builtins.map (ip: "listen ${ip}:443 http3;") listenIPs)
    + ''
      add_header Alt-Svc 'h3=":443"';
    '';
  clean-cache = nix-packages.packages.${system}.clean-s3-cache;
  machines = pkgs.writeText "machines" ''
    localhost armv7l-linux,aarch64-linux,powerpc-linux,powerpc64-linux,powerpc64le-linux,riscv32-linux,riscv64-linux,wasm32-wasi,x86_64-linux,i686-linux - 12 1 kvm,nixos-test,big-parallel,benchmark,gccarch-znver1,gccarch-skylake,ca-derivations  -
    ssh://build-aarch64 aarch64-linux - 2 10 nixos-test,benchmark,ca-derivations  -
  '';
in {
  imports = [
    ./postgres.nix
    ../../modules/hydra.nix
  ];
  services.hydra = {
    enable = true;
    package = pkgs.hydra-unstable;
    hydraURL = "https://hydra.chir.rs/";
    notificationSender = "hydra@chir.rs";
    useSubstitutes = true;
    port = 3001;
    extraConfig = ''
      <gitea_authorization>
        darkkirb = #gitea_token#
      </gitea_authorization>
      <github_authorization>
        DarkKirb = Bearer #github_token#
      </github_authorization>
      <githubstatus>
        jobs = .*
      </githubstatus>
      <hydra_notify>
        <prometheus>
          listen_address = 127.0.0.1
          port = 9199
        </prometheus>
      </hydra_notify>
      binary_cache_secret_key_file = ${config.sops.secrets."services/hydra/cache-key".path}
      <git-input>
        timeout = 3600
      </git-input>
    '';
    giteaTokenFile = "/run/secrets/services/hydra/gitea_token";
    githubTokenFile = "/run/secrets/services/hydra/github_token";
    buildMachinesFiles = [
      "${machines}"
      "/run/hydra-machines"
    ];
  };
  networking.firewall.interfaces."wg0".allowedTCPPorts = [9199];
  nix.settings.allowed-uris = ["https://github.com/" "https://git.chir.rs/" "https://darkkirb.de/" "https://git.neo-layout.org/" "https://static.darkkirb.de/" "https://gist.github.com/" "https://git.kescher.at/" "https://akkoma.dev/" "https://gitlab.com/" "https://api.github.com/" "https://git.sr.ht/"];
  sops.secrets."services/hydra/gitea_token" = {};
  sops.secrets."services/hydra/github_token" = {};
  sops.secrets."services/hydra/cache-key" = {
    owner = "hydra-www";
    mode = "0440";
  };
  services.caddy.virtualHosts."hydra.int.chir.rs" = {
    useACMEHost = "int.chir.rs";
    logFormat = pkgs.lib.mkForce "";
    extraConfig = ''
      import baseConfig

      reverse_proxy http://127.0.0.1:${toString config.services.hydra.port} {
        trusted_proxies private_ranges
      }
    '';
  };
  systemd.services.clean-s3-cache = {
    enable = true;
    description = "Clean up S3 cache";
    serviceConfig = {
      ExecStart = "${clean-cache}/bin/clean-s3-cache.py";
    };
  };
  systemd.timers.clean-s3-cache = {
    enable = true;
    description = "Clean up S3 cache";
    requires = ["clean-s3-cache.service"];
    wantedBy = ["multi-user.target"];
    timerConfig = {
      OnBootSec = 300;
      OnUnitActiveSec = 604800;
    };
  };
  sops.secrets."services/hydra/aws_credentials" = {
    owner = "hydra-queue-runner";
    path = "/var/lib/hydra/queue-runner/.aws/credentials";
    restartUnits = ["hydra-notify.service"];
  };
  systemd.services.update-hydra-hosts = {
    description = "Update hydra hosts";
    serviceConfig = {
      Type = "oneshot";
    };
    script = ''
      if ${pkgs.iputils}/bin/ping -c 1 nutty-noon.int.chir.rs; then
        echo "build-pc armv7l-linux,aarch64-linux,powerpc-linux,powerpc64-linux,powerpc64le-linux,riscv32-linux,riscv64-linux,wasm32-wasi,x86_64-linux,i686-linux - 16 2 kvm,nixos-test,big-parallel,benchmark,gccarch-znver2,gccarch-znver1,gccarch-skylake,ca-derivations  -" > /run/hydra-machines
      else
        rm -f /run/hydra-machines
      fi
    '';
  };
  systemd.timers.update-hydra-hosts = {
    enable = true;
    description = "Update hydra hosts";
    requires = ["update-hydra-hosts.service"];
    wantedBy = ["multi-user.target"];
    timerConfig = {
      OnBootSec = 300;
      OnUnitActiveSec = 300;
    };
  };
  nix.settings.trusted-users = ["@hydra"];
  sops.secrets."hydra/ssh/builder_id_ed25519" = {
    sopsFile = ../../secrets/shared.yaml;
    owner = "hydra";
    key = "ssh/builder_id_ed25519";
    path = "/var/lib/hydra/.ssh/builder_id_ed25519";
  };
}
