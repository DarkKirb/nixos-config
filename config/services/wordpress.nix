{
  lib,
  pkgs,
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
        indieauth
        syndication-links
        micropub
        webmention
        activitypub
        friends
        webfinger
        nodeinfo
        classic-editor
        wordpress-seo
        modern-footnotes
        the-plus-addons-for-block-editor
        shortcoder
        wp-dark-mode
        wp-super-cache
        ;
    };
    themes = {
      inherit
        (pkgs.wordpress-themes)
        sempress
        twentytwentythree
        ;
    };
    poolConfig = {
      pm = "dynamic";
      "pm.max_children" = 460;
      "pm.start_servers" = 4;
      "pm.min_spare_servers" = 4;
      "pm.max_spare_servers" = 64;
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
