{
  pkgs,
  nix-packages,
  config,
  lib,
  ...
}: let
  emoji_set_names = ["volpeon-blobfox-flip" "volpeon-blobfox" "volpeon-bunhd-flip" "volpeon-bunhd" "volpeon-drgn" "volpeon-fox" "volpeon-raccoon" "volpeon-vlpn" "lotte"];
  emoji_sets = builtins.listToAttrs (map (name: {
      inherit name;
      value = "${pkgs."emoji-${name}"}";
    })
    emoji_set_names);
  copy_emoji_set = name: ''
    mkdir -p $out/emoji/${name}
    lndir ${emoji_sets.${name}} $out/emoji/${name}
  '';
  static_dir = pkgs.stdenvNoCC.mkDerivation {
    name = "akkoma-static";
    src = pkgs.emptyDirectory;
    nativeBuildInputs = with pkgs; [xorg.lndir];
    akkoma_fe = nix-packages.packages.${pkgs.system}.pleroma-fe;
    akkoma_admin_fe = nix-packages.packages.${pkgs.system}.admin-fe;
    tos = ./terms-of-service.html;
    dontUnpack = false;
    installPhase = ''
      mkdir -p $out/frontends/pleroma-fe/stable
      lndir $akkoma_fe $out/frontends/pleroma-fe/stable
      mkdir -p $out/frontends/admin-fe/stable
      lndir $akkoma_admin_fe $out/frontends/admin-fe/stable
      ${toString (map copy_emoji_set emoji_set_names)}
      mkdir $out/emoji/misc
      ln -s ${./therian.png} $out/emoji/misc
      mkdir $out/static
      cp $tos $out/static/terms-of-service.html
    '';
  };
  ec = pkgs.formats.elixirConf {};
  akkconfig = ec.generate "config.exs" (with ec.lib; {
    ":pleroma" = {
      "Pleroma.Upload" = {
        uploader = mkRaw "Pleroma.Uploaders.S3";
        filters = map (v: mkRaw ("Pleroma.Upload.Filter." + v)) ["Mogrify" "Exiftool" "Dedupe" "AnonymizeFilename"];
        base_url = "https://mastodon-assets.chir.rs/";
      };
      "Pleroma.Uploaders.S3" = {
        bucket = "mastodon-chir-rs";
        truncated_namespace = "";
      };
      "Pleroma.Upload.Filter.Mogrify" = {
        args = "auto-orient";
      };
      ":instance" = {
        name = "Raccoon Noises";
        email = "lotte@chir.rs";
        description = "Single User Akkoma Instance";
        limit = 58913;
        description_limit = 58913;
        upload_limit = 134217728;
        languages = ["en" "tok"];
        registrations_open = false;
        invites_enabled = true;
        static_dir = "${static_dir}";
        max_pinned_statuses = 10;
        attachment_links = true;
        max_report_comment_size = 58913;
        safe_dm_mentions = true;
        healthcheck = true;
        user_bio_length = 58913;
        user_name_length = 621;
        max_account_fields = 69;
        max_remote_account_fields = 621;
        account_field_name_length = 621;
        account_field_value_length = 58913;
        registration_reason_length = 621;
        external_user_synchronization = true;
        cleanup_attachments = true;
      };
      ":markup" = {
        allow_headings = true;
        allow_tables = true;
        allow_fonts = true;
      };
      ":frontend_configurations" = {
        pleroma_fe = mkMap {
          webPushNotifications = true;
        };
      };
      ":activitypub" = {
        unfollow_blocked = false;
        outgoing_blocks = false;
        blockers_visible = false;
        deny_follow_blocked = true;
        sign_object_fetches = true;
        authorized_fetch_mode = true;
      };
      ":mrf_simple" = let
        processMap = m: map (k: mkTuple [k m.${k}]) (builtins.attrNames m);
      in {
        reject = processMap {
          "qoto.org" = "Freeze Peach";
          "poa.st" = "Hosting neonazis";
          "kiwifarms.cc" = "Targeted Harassment";
          "pmth.us" = "Harassment";
          "nicecrew.digital" = "TERF Instance";
          "freespeechextremist.com" = "Freeze Peach";
          "ryona.agency" = "Freeze Peach";
          "howlr.me" = "Run by verified kiwifarms user";
          "rdrama.cc" = "smells like Kiwifarms shit";
          "xhais.love" = "Zoophile instance";
          "beefyboys.win" = "freeze peach; hosts neonazis";
          "bae.st" = "freeze peach";
        };
        media_removal = processMap {
          "a.rathersafe.space" = "posting borderline illegal imagery as the fediblock account";
        };
      };
      ":mrf" = {
        policies = map (v: mkRaw ("Pleroma.Web.ActivityPub.MRF." + v)) ["SimplePolicy" "EnsureRePrepended" "MediaProxyWarmingPolicy" "ForceBotUnlistedPolicy" "AntiFollowbotPolicy" "ObjectAgePolicy" "TagPolicy" "RequireImageDescription"];
        transparency = true;
      };
      ":http_security" = {
        enabled = true;
        sts = true;
        referrer_policy = "no-referrer";
      };
      ":frontends" = {
        primary = mkMap {
          name = "pleroma-fe";
          ref = "stable";
        };
        admin = mkMap {
          name = "admin-fe";
          ref = "stable";
        };
      };
      ":media_proxy" = {
        enabled = true;
        proxy_opts = {
          redirect_on_failure = true;
        };
      };
      "Pleroma.Repo" = {
        adapter = mkRaw "Ecto.Adapters.Postgres";
        database = "akkoma";
        pool_size = 10;
        socket_dir = "/run/postgresql";
        prepare = mkAtom ":named";
        parameters.plan_cache_mode = "force_custom_plan";
      };
      "Pleroma.Web.Endpoint" = {
        url = {
          host = "akko.chir.rs";
          port = 443;
          scheme = "https";
        };
        secure_cookie_flag = true;
      };
      "Pleroma.Emails.Mailer" = {
        enabled = true;
        adapter = mkRaw "Swoosh.Adapters.SMTP";
        relay = "mail.chir.rs";
        username = "akko@chir.rs";
        port = "465";
        ssl = true;
        auth = mkAtom ":always";
      };
      "Pleroma.Emails.NewUsersDigestEmail" = {
        enabled = true;
      };
      ":database".rum_enabled = true;
      ":emoji" = {
        shortcode_globs = ["/emoji/**/*.png"];
        groups = {
          "BlobfoxFlip" = "/emoji/volpeon-blobfox-flip/*.png";
          "Blobfox" = "/emoji/volpeon-blobfox/*.png";
          "BunhdFlip" = "/emoji/volpeon-bunhd-flip/*.png";
          "Bunhd" = "/emoji/volpeon-bunhd/*.png";
          "Drgn" = "/emoji/volpeon-drgn/*.png";
          "Fox" = "/emoji/volpeon-fox/*.png";
          "Raccoon" = "/emoji/volpeon-raccoon/*.png";
          "Vlpn" = "/emoji/volpeon-vlpn/*.png";
          "Lotte" = "/emoji/lotte/*.png";
          "Misc" = "/emoji/misc/*.png";
        };
      };
    };
    ":web_push_encryption".":vapid_details".subject = "lotte@chir.rs";
  });
in {
  imports = [
    ./mediaproxy.nix
  ];
  services.pleroma = {
    enable = true;
    package = nix-packages.packages.${pkgs.system}.akkoma;
    configs = [(builtins.readFile akkconfig)];
    user = "akkoma";
    group = "akkoma";
    secretConfigFile = config.sops.secrets."services/akkoma.exs".path;
  };
  systemd.services.pleroma.path = with pkgs; [exiftool imagemagick ffmpeg];
  services.postgresql.ensureDatabases = ["akkoma"];
  services.postgresql.ensureUsers = [
    {
      name = "akkoma";
      ensurePermissions = {"DATABASE akkoma" = "ALL PRIVILEGES";};
    }
  ];
  sops.secrets."services/akkoma.exs" = {owner = "akkoma";};
  services.caddy.virtualHosts."akko.chir.rs" = {
    useACMEHost = "chir.rs";
    extraConfig = ''
      import baseConfig
      handle /media_attachments/* {
        redir https://mastodon-assets.chir.rs{uri} permanent
      }
      handle /proxy/* {
        reverse_proxy {
          to http://127.0.0.1:24154
        }
      }
      handle {
        reverse_proxy {
          to http://127.0.0.1:4000
        }
      }
    '';
  };

  services.postgresql.extraPlugins = with pkgs.postgresql_13.pkgs; [rum];
}
