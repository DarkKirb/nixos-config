{
  system,
  attic,
  lib,
  config,
  pkgs,
  hydra,
  nix-eval-jobs,
  ...
}:
let
  machines = pkgs.writeText "machines" ''
    localhost armv7l-linux,powerpc-linux,powerpc64-linux,powerpc64le-linux,wasm32-wasi,x86_64-linux,i686-linux - 16 1 kvm,nixos-test,big-parallel,benchmark,gccarch-znver4,gccarch-znver3,gccarch-znver2,gccarch-znver1,gccarch-skylake,gccarch-skylake-avx512,ca-derivations  -
    build-aarch64 aarch64-linux - 4 1 nixos-test,benchmark,ca-derivations,gccarch-armv8-a,gccarch-armv8.1-a,gccarch-armv8.2-a,big-parallel  -
    build-riscv riscv64-linux,riscv32-linux - 4 2 nixos-test,benchmark,ca-derivations,gccarch-rv64gc_zba_zbb,gccarch-rv64gc_zba,gccarch-rv64gc_zbb,ccarch-rv64gc,gccarch-rv32gc_zba_zbb,gccarch-rv32gc_zba,gccarch-rv32gc_zbb,gccarch-rv32gc,big-parallel,native-riscv  -
  '';
  sshConfig =
    home:
    pkgs.writeText "ssh-config" ''
      Host build-aarch64
        Port 22
        IdentitiesOnly yes
        User remote-build
        HostName instance-20221213-1915.int.chir.rs
        IdentityFile ${home}/.ssh/builder_id_ed25519
      Host build-rainbow-resort
        Port 22
        IdentitiesOnly yes
        User remote-build
        HostName rainbow-resort.int.chir.rs
        IdentityFile ${home}/.ssh/builder_id_ed25519
      Host build-riscv
        Port 22
        IdentitiesOnly yes
        User remote-build
        HostName not522.tailbab65.ts.net
        IdentityFile ${home}/.ssh/builder_id_ed25519

      Host *
        ForwardAgent no
        Compression no
        ServerAliveInterval 0
        ServerAliveCountMax 3
        HashKnownHosts no
        UserKnownHostsFile ~/.ssh/known_hosts
        ControlMaster auto
        ControlPath ~/.ssh/master-%r@%n:%p
        ControlPersist 10m
    '';
  nix-eval-jobs-script = pkgs.stdenvNoCC.mkDerivation {
    name = "remote-eval-jobs.py";
    src = ./remote-eval-jobs.py;
    dontUnpack = true;
    dontBuild = true;
    installPhase = ''
      substitute $src $out \
        --subst-var-by python3 ${lib.getExe pkgs.python3} \
        --subst-var-by ping ${lib.getExe' pkgs.iputils "ping"} \
        --subst-var-by nix-eval-jobs ${lib.getExe' nix-eval-jobs.packages.x86_64-linux.nix-eval-jobs "nix-eval-jobs"} \
        --subst-var-by nix ${lib.getExe config.nix.package} \
        --subst-var-by ssh ${lib.getExe pkgs.openssh}
      chmod +x $out
    '';
  };
in
{
  services.postgresql.enable = true;
  imports = [
    hydra.nixosModules.hydra
  ];
  nixpkgs.overlays = [
    hydra.overlays.default
  ];
  services.hydra-dev = {
    enable = true;
    dbi = "dbi:Pg:dbname=hydra;user=hydra;host=127.0.0.1;port=5432";
    package = hydra.packages.${system}.hydra.overrideAttrs (super: {
      doCheck = false;
      doInstallCheck = false;
      patches = super.patches or [ ] ++ [
        ./0001-add-gitea-pulls.patch
        ./0002-unlimit-output.patch
        ./0003-remove-pr-number-from-github-job-name.patch
        ./0004-use-pulls-instead-of-issues.patch
        ./0005-only-list-open-prs.patch
        ./0006-status-state.patch
        ./0007-hydra-server-findLog-fix-issue-with-ca-derivations-e.patch
      ];
    });
    hydraURL = "https://hydra.chir.rs/";
    notificationSender = "hydra@chir.rs";
    useSubstitutes = true;
    port = 3001;
    extraConfig = ''
      include ${config.sops.secrets."services/hydra/gitea_token".path}
      include ${config.sops.secrets."services/hydra/github_token".path}
      <githubstatus>
        jobs = .*
      </githubstatus>
      <hydra_notify>
        <prometheus>
          listen_address = 0.0.0.0
          port = 8905
        </prometheus>
      </hydra_notify>
      binary_cache_secret_key_file = ${config.sops.secrets."services/hydra/cache-key".path}
      <git-input>
        timeout = 3600
      </git-input>
      <runcommand>
        job = *:*:*
        command = cat $HYDRA_JSON | ${pkgs.jq}/bin/jq -r '.drvPath' >> /var/lib/hydra/queue-runner/upload
      </runcommand>
      max_concurrent_evals = 1
    '';
    buildMachinesFiles = [
      "${machines}"
      "/run/hydra-machines"
    ];
  };
  nix.settings.allowed-uris = [
    "github:"
    "https://"
    "http://"
  ];
  sops.secrets."services/hydra/gitea_token" = {
    sopsFile = ./secrets.yaml;
    owner = "hydra";
    mode = "0440";
  };
  sops.secrets."services/hydra/github_token" = {
    sopsFile = ./secrets.yaml;
    owner = "hydra";
    mode = "0440";
  };
  sops.secrets."services/hydra/cache-key" = {
    owner = "hydra-www";
    mode = "0440";
    sopsFile = ./secrets.yaml;
  };
  services.caddy.virtualHosts."hydra.int.chir.rs" = {
    useACMEHost = "int.chir.rs";
    logFormat = pkgs.lib.mkForce "";
    extraConfig = ''
      import baseConfig

      reverse_proxy http://127.0.0.1:${toString config.services.hydra-dev.port} {
        trusted_proxies private_ranges
        header_up Host hydra.chir.rs
      }
    '';
  };
  sops.secrets."services/hydra/aws_credentials" = {
    owner = "hydra-queue-runner";
    path = "/var/lib/hydra/queue-runner/.aws/credentials";
    restartUnits = [ "hydra-notify.service" ];
    sopsFile = ./secrets.yaml;
  };
  nix.settings.trusted-users = [ "@hydra" ];
  sops.secrets."hydra-evaluator/.ssh/builder_id_ed25519" = {
    mode = "600";
    owner = "hydra";
    key = ".ssh/builder_id_ed25519";
    path = "/var/lib/hydra/.ssh/builder_id_ed25519";
    sopsFile = ../../programs/ssh/shared-keys.yaml;
  };
  sops.secrets."hydra/.ssh/builder_id_ed25519" = {
    mode = "600";
    owner = "hydra-queue-runner";
    key = ".ssh/builder_id_ed25519";
    path = "/var/lib/hydra/queue-runner/.ssh/builder_id_ed25519";
    sopsFile = ../../programs/ssh/shared-keys.yaml;
  };

  system.activationScripts.setupHydraSshConfig = lib.stringAfter [ "var" ] ''
    mkdir -p /var/lib/hydra/queue-runner/.ssh/
    chown -Rv hydra-queue-runner /var/lib/hydra/queue-runner
    ln -svf ${sshConfig "/var/lib/hydra/queue-runner"} /var/lib/hydra/queue-runner/.ssh/config
    mkdir -p /var/lib/hydra/.ssh/
    chown -Rv hydra /var/lib/hydra/.ssh
    ln -svf ${sshConfig "/var/lib/hydra"} /var/lib/hydra/.ssh/config
  '';
  sops.secrets."attic/config.toml" = {
    owner = "hydra-queue-runner";
    key = "attic/config.toml";
    path = "/var/lib/hydra/queue-runner/.config/attic/config.toml";
    sopsFile = ./secrets.yaml;
  };
  services.postgresql.ensureDatabases = [
    "hydra-queue-runner"
    "hydra"
  ];
  services.postgresql.ensureUsers = [
    {
      name = "hydra-queue-runner";
      ensureDBOwnership = true;
    }
    {
      name = "hydra";
      ensureDBOwnership = true;
    }
  ];

  systemd.services."attic-queue" = {
    description = "Upload build results";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      User = "hydra-queue-runner";
      Group = "hydra";
      EnvironmentFile = config.sops.secrets."systemd/services/attic-queue/serviceConfig/environment".path;
    };
    environment = {
      QUEUE_PATH = "/var/lib/hydra/queue-runner/upload";
      RUST_LOG = "info";
    };
    script = lib.getExe' attic.packages.${system}.attic-queue "attic-queue";

  };
  sops.secrets."systemd/services/attic-queue/serviceConfig/environment".sopsFile = ./secrets.yaml;
  sops.secrets."services/hydra/environment".sopsFile = ./secrets.yaml;
  services.pgbouncer.settings.databases = {
    hydra = "host=127.0.0.1 port=5432 auth_user=hydra dbname=hydra";
    hydra-queue-runner = "host=127.0.0.1 port=5432 auth_user=hydra-queue-runner dbname=hydra-queue-runner";
  };
  systemd.services.hydra-init.serviceConfig.EnvironmentFile =
    config.sops.secrets."services/hydra/environment".path;
  systemd.services.hydra-server.serviceConfig.EnvironmentFile =
    config.sops.secrets."services/hydra/environment".path;
  systemd.services.hydra-queue-runner.serviceConfig.EnvironmentFile =
    config.sops.secrets."services/hydra/environment".path;
  systemd.services.hydra-evaluator.serviceConfig.EnvironmentFile =
    config.sops.secrets."services/hydra/environment".path;
  systemd.services.hydra-update-gc-roots.serviceConfig.EnvironmentFile =
    config.sops.secrets."services/hydra/environment".path;
  systemd.services.hydra-send-stats.serviceConfig.EnvironmentFile =
    config.sops.secrets."services/hydra/environment".path;
  systemd.services.hydra-notify.serviceConfig.EnvironmentFile =
    config.sops.secrets."services/hydra/environment".path;
  systemd.services.hydra-check-space.serviceConfig.EnvironmentFile =
    config.sops.secrets."services/hydra/environment".path;
  systemd.services.hydra-compress-logs.serviceConfig.EnvironmentFile =
    config.sops.secrets."services/hydra/environment".path;
}
