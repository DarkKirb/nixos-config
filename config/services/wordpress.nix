{
  lib,
  pkgs,
  config,
  ...
}: {
  imports = [../../modules/wordpress.nix];
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };

  services.wordpress.webserver = "caddy";
  services.wordpress.sites."lotte.chir.rs" = {
    settings = {
      # Needed to run behind reverse proxy
      FORCE_SSL_ADMIN = true;
    };
    extraConfig = ''
      $_SERVER['HTTPS']='on';
    '';

    plugins = {
      inherit
        (pkgs.wordpress-plugins)
        google-sitemap-generator
        indieweb
        pubsubhubbub
        indieweb-post-kinds
        indeiauth
        syndication-links
        micropub
        webmention
        activitypub
        friends
        hum
        webfinger
        nodeinfo
        classic-editor
        wordpress-seo
        ilab-media-tools
        translatepress-multilingual
        webp-express
        jetpack
        ;
    };
    themes = {
      inherit
        (pkgs.wordpress-themes)
        sempress
        twentytwentythree
        ;
    };
  };

  nixpkgs.overlays = [
    (self: super: {
      wordpress = super.wordpress.overrideAttrs (oldAttrs: {
        installPhase =
          oldAttrs.installPhase
          + ''
            ln -s /var/lib/wordpress/lotte.chir.rs/webp-express $out/share/wordpress/wp-content/webp-express
          '';
      });
    })
  ];

  systemd.tmpfiles.rules = [
    "d '/var/lib/wordpress/lotte.chir.rs/webp-express' 0750 wordpress acme - -"
  ];

  services.caddy.virtualHosts."lotte.chir.rs" = {
    useACMEHost = "chir.rs";
    logFormat = lib.mkForce "";
    extraConfig = ''
      import baseConfig
    '';
  };
}
