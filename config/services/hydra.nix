{
  system,
  attic,
  lib,
  config,
  pkgs,
  hydra,
  ...
}: let
  machines = pkgs.writeText "machines" ''
    localhost armv7l-linux,powerpc-linux,powerpc64-linux,powerpc64le-linux,wasm32-wasi,x86_64-linux,i686-linux,riscv32-linux,riscv64-linux - 12 1 kvm,nixos-test,big-parallel,benchmark,gccarch-znver1,gccarch-skylake,ca-derivations  -
    build-aarch64 aarch64-linux,riscv32-linux,riscv64-linux - 4 1 nixos-test,benchmark,ca-derivations,gccarch-armv8-a,gccarch-armv8.1-a,gccarch-armv8.2-a,big-parallel  -
    build-riscv riscv64-linux,riscv32-linux - 4 2 nixos-test,benchmark,ca-derivations,gccarch-rv64gc_zba_zbb,gccarch-rv64gc_zba,gccarch-rv64gc_zbb,ccarch-rv64gc,gccarch-rv32gc_zba_zbb,gccarch-rv32gc_zba,gccarch-rv32gc_zbb,gccarch-rv32gc,big-parallel,native-riscv  -
  '';
  sshConfig = pkgs.writeText "ssh-config" ''
    Host build-aarch64
      Port 22
      IdentitiesOnly yes
      User remote-build
      HostName instance-20221213-1915.int.chir.rs
      IdentityFile /var/lib/hydra/queue-runner/.ssh/builder_id_ed25519
    Host build-nas
      Port 22
      IdentitiesOnly yes
      User remote-build
      HostName nas.int.chir.rs
      IdentityFile /var/lib/hydra/queue-runner/.ssh/builder_id_ed25519
    Host build-rainbow-resort
      Port 22
      IdentitiesOnly yes
      User remote-build
      HostName rainbow-resort.int.chir.rs
      IdentityFile /var/lib/hydra/queue-runner/.ssh/builder_id_ed25519
    Host build-riscv
      Port 22
      IdentitiesOnly yes
      User remote-build
      HostName not522.tailbab65.ts.net
      IdentityFile /var/lib/hydra/queue-runner/.ssh/builder_id_ed25519

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
in {
  imports = [
    ./postgres.nix
    ../../modules/hydra.nix
    hydra.nixosModules.hydra
  ];
  nixpkgs.overlays = [
    hydra.overlays.default
  ];
  services.hydra-dev = {
    enable = true;
    package = hydra.packages.${system}.hydra.overrideAttrs (super: {
      doCheck = false;
      doInstallCheck = false;
      patches =
        super.patches
        or []
        ++ [
          ./hydra/0001-add-gitea-pulls.patch
          ./hydra/0002-unlimit-output.patch
          ./hydra/0003-remove-pr-number-from-github-job-name.patch
          ./hydra/0004-use-pulls-instead-of-issues.patch
          ./hydra/0005-only-list-open-prs.patch
          ./hydra/0006-status-state.patch
          ./hydra/0007-hydra-server-findLog-fix-issue-with-ca-derivations-e.patch
        ];
    });
    hydraURL = "https://hydra.chir.rs/";
    notificationSender = "hydra@chir.rs";
    useSubstitutes = true;
    port = 3001;
    extraConfig = ''
      <gitea_authorization>
        darkkirb = #gitea_token#
        ProcyOS = #gitea_token#
      </gitea_authorization>
      <github_authorization>
        DarkKirb = Bearer #github_token#
      </github_authorization>
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
    giteaTokenFile = "/run/secrets/services/hydra/gitea_token";
    githubTokenFile = "/run/secrets/services/hydra/github_token";
    buildMachinesFiles = [
      "${machines}"
      "/run/hydra-machines"
    ];
  };
  nix.settings.allowed-uris = ["github:" "https://" "http://"];
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

      reverse_proxy http://127.0.0.1:${toString config.services.hydra-dev.port} {
        trusted_proxies private_ranges
      }
    '';
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
      if ${pkgs.iputils}/bin/ping -c 1 rainbow-resort.int.chir.rs; then
        echo "build-rainbow-resort armv7l-linux,powerpc-linux,powerpc64-linux,powerpc64le-linux,wasm32-wasi,x86_64-linux,i686-linux,riscv32-linux,riscv64-linux - 16 1 kvm,nixos-test,big-parallel,benchmark,gccarch-znver4,gccarch-znver3,gccarch-znver2,gccarch-znver1,gccarch-skylake,gccarch-skylake-avx512,ca-derivations  -" > /run/hydra-machines
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
    owner = "hydra-queue-runner";
    key = "ssh/builder_id_ed25519";
    path = "/var/lib/hydra/queue-runner/.ssh/builder_id_ed25519";
  };
  system.activationScripts.setupHydraSshConfig = lib.stringAfter ["var"] ''
    mkdir -p /var/lib/hydra/queue-runner/.ssh/
    chown -Rv hydra-queue-runner /var/lib/hydra/queue-runner
    ln -svf ${sshConfig} /var/lib/hydra/queue-runner/.ssh/config
  '';
  sops.secrets."attic/config.toml" = {
    owner = "hydra-queue-runner";
    key = "attic/config.toml";
    path = "/var/lib/hydra/queue-runner/.config/attic/config.toml";
  };
  services.postgresql.ensureDatabases = [
    "hydra-queue-runner"
  ];
  services.postgresql.ensureUsers = [
    {
      name = "hydra-queue-runner";
      ensureDBOwnership = true;
    }
  ];

  systemd.services."attic-queue" = {
    description = "Upload build results";
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      User = "hydra-queue-runner";
      Group = "hydra";
    };
    script = ''
      export QUEUE_PATH=/var/lib/hydra/queue-runner/upload
      export DATABASE_PATH=postgresql:///hydra-queue-runner
      export RUST_LOG=info
      exec ${attic.packages.${system}.attic-queue}/bin/attic-queue
    '';
  };
}
