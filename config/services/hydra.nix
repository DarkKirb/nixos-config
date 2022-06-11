{ system, nix-packages, lib, config, pkgs, ... }:
let
  listenIPs = (import ../../utils/getInternalIP.nix config).listenIPs;
  listenStatements = lib.concatStringsSep "\n" (builtins.map (ip: "listen ${ip}:443 http3;") listenIPs) + ''
    add_header Alt-Svc 'h3=":443"';
  '';
  clean-cache = nix-packages.packages.${system}.clean-s3-cache;
  machines = pkgs.writeText "machines" ''
    localhost armv7l-linux,aarch64-linux,powerpc-linux,powerpc64-linux,powerpc64le-linux,riscv32-linux,riscv64-linux,wasm32-wasi,x86_64-linux,i686-linux - 12 1 kvm,nixos-test,big-parallel,benchmark,gccarch-znver1,gccarch-skylake,ca-derivations  -
  '';
  run_deploy = pkgs.writeScript "run_deploy" ''
    export GITHUB_TOKEN=$(cat /run/secrets/services/hydra/github_token)

    ${pkgs.github-cli}/bin/gh workflow run deploy.yml -R
  '';
in
{
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
      store_uri = s3://cache-chir-rs?scheme=https&endpoint=s3.us-west-000.backblazeb2.com&secret-key=${config.sops.secrets."services/hydra/cache-key".path}&multipart-upload=true&compression=zstd&compression-level=15
      <hydra_notify>
        <prometheus>
          listen_address = 127.0.0.1
          port = 9199
        </prometheus>
      </hydra_notify>
      <runcommand>
        job = nixos-config:nixos-config:*
        command = cat $HYDRA_JSON > /tmp/hydra-output
      </runcommand>
    '';
    giteaTokenFile = "/run/secrets/services/hydra/gitea_token";
    githubTokenFile = "/run/secrets/services/hydra/github_token";
    buildMachinesFiles = [
      "${machines}"
      "/run/hydra-machines"
    ];
  };
  networking.firewall.interfaces."wg0".allowedTCPPorts = [ 9199 ];
  nix.settings.allowed-uris = [ "https://github.com/" "https://git.chir.rs/" "https://darkkirb.de/" "https://git.neo-layout.org/" "https://static.darkkirb.de/" ];
  sops.secrets."services/hydra/gitea_token" = { };
  sops.secrets."services/hydra/github_token" = { };
  sops.secrets."services/hydra/cache-key" = {
    owner = "hydra-queue-runner";
  };
  services.nginx.virtualHosts."hydra.chir.rs" = {
    listenAddresses = listenIPs;
    sslCertificate = "/var/lib/acme/chir.rs/cert.pem";
    sslCertificateKey = "/var/lib/acme/chir.rs/key.pem";
    locations."/" = {
      proxyPass = "http://127.0.0.1:3000";
      proxyWebsockets = true;
    };
    extraConfig = listenStatements;
  };
  services.nginx.virtualHosts."hydra.int.chir.rs" = {
    listenAddresses = listenIPs;
    sslCertificate = "/var/lib/acme/int.chir.rs/cert.pem";
    sslCertificateKey = "/var/lib/acme/int.chir.rs/key.pem";
    locations."/" = {
      proxyPass = "http://127.0.0.1:3000";
      proxyWebsockets = true;
    };
    extraConfig = listenStatements;
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
    requires = [ "clean-s3-cache.service" ];
    wantedBy = [ "multi-user.target" ];
    timerConfig = {
      OnBootSec = 300;
      OnUnitActiveSec = 604800;
    };
  };
  sops.secrets."services/hydra/aws_credentials" = {
    owner = "hydra-queue-runner";
    path = "/var/lib/hydra/queue-runner/.aws/credentials";
    restartUnits = [ "hydra-queue-runner.service" ];
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
    requires = [ "update-hydra-hosts.service" ];
    wantedBy = [ "multi-user.target" ];
    timerConfig = {
      OnBootSec = 300;
      OnUnitActiveSec = 300;
    };
  };
}
