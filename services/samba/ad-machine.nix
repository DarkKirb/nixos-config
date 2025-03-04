#
# nixos-ad.nix -- Active Directory Client
#
# Join AD: sudo adcli join --domain=your.domain.com --user=administrator
#
{
  pkgs,
  lib,
  ...
}:
{
  networking.search = [ "ad.chir.rs" ];
  networking.nameservers = [ "100.97.198.107" ];
  #
  # Packages
  #
  environment.systemPackages = with pkgs; [
    adcli # Helper library and tools for Active Directory client operations
    oddjob # Odd Job Daemon
    samba4Full # Standard Windows interoperability suite of programs for Linux and Unix
    sssd # System Security Services Daemon
    krb5 # MIT Kerberos 5
    realmd # DBus service for configuring Kerberos and other
  ];

  #
  # Security
  #
  security = {
    pam = {
      makeHomeDir.umask = "077";
      services.login.makeHomeDir = true;
      services.sshd.makeHomeDir = true;
    };

    sudo = {
      extraConfig = ''
        %domain\ admins ALL=(ALL:ALL) NOPASSWD: ALL
        Defaults:%domain\ admins env_keep+=TERMINFO_DIRS
        Defaults:%domain\ admins env_keep+=TERMINFO
      '';

      # Use extraConfig because of blank space in 'domain admins'.
      # Alternatively, you can use the GID.
      # extraRules = [
      #   { groups = [ "domain admins" ];
      #     commands = [ { command = "ALL"; options = [ "NOPASSWD" ]; }  ]; }
      # ];
    };
  };

  #
  # Services
  #
  services = {
    nscd = {
      enable = true;
      config = ''
        server-user nscd
        enable-cache hosts yes
        positive-time-to-live hosts 0
        negative-time-to-live hosts 0
        shared hosts yes
        enable-cache passwd no
        enable-cache group no
        enable-cache netgroup no
        enable-cache services no
      '';
    };

    sssd = {
      enable = true;
      config = ''
        [sssd]
        domains = ad.chir.rs
        config_file_version = 2
        services = nss, pam

        [domain/ad.chir.rs]
        override_shell = ${lib.getExe pkgs.bashInteractive}
        krb5_store_password_if_offline = True
        cache_credentials = True
        krb5_realm = AD.CHIR.RS
        realmd_tags = manages-system joined-with-samba
        id_provider = ad
        fallback_homedir = /home/%u
        ad_domain = ad.chir.rs
        use_fully_qualified_names = false
        ldap_id_mapping = false
        auth_provider = ad
        access_provider = ad
        chpass_provider = ad
        ad_gpo_access_control = permissive
        enumerate = true
      '';
    };
  };

  #
  # Systemd
  #
  systemd = {
    services.realmd = {
      description = "Realm Discovery Service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        Type = "dbus";
        BusName = "org.freedesktop.realmd";
        ExecStart = "${pkgs.realmd}/libexec/realmd";
        User = "root";
      };
    };
  };
}
