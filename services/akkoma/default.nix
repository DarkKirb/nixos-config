{
  pkgs,
  config,
  system,
  akkoma,
  admin-fe,
  akkoma-fe,
  ...
}:
let
  emoji_set_names = [
    "caro"
    "lotte"
    "volpeon-blobfox"
    "volpeon-bunhd"
    "volpeon-drgn"
    "volpeon-floof"
    "volpeon-fox"
    "volpeon-gphn"
    "volpeon-neocat"
    "volpeon-neofox"
    "volpeon-raccoon"
    "volpeon-vlpn"
    "volpeon-wvrn"
    "rosaflags"
    "neopossum"
  ];
  emoji_sets = builtins.listToAttrs (
    map (name: {
      inherit name;
      value = "${pkgs."emoji-${name}"}";
    }) emoji_set_names
  );
  copy_emoji_set = name: ''
    mkdir -p $out/emoji/${name}
    lndir ${emoji_sets.${name}} $out/emoji/${name}
  '';
  fedibird_fe = pkgs.fetchzip {
    url = "https://akkoma-updates.s3-website.fr-par.scw.cloud/frontend/akkoma/fedibird-fe.zip";
    sha256 = "sha256-hUp8XAQInWB3BpTrwsTV36xNwxs6fK01fFAd4FBwn4U=";
  };
  static_dir = pkgs.stdenvNoCC.mkDerivation {
    name = "akkoma-static";
    src = pkgs.emptyDirectory;
    nativeBuildInputs = with pkgs; [ xorg.lndir ];
    akkoma_fe = akkoma-fe.packages.${system}.akkoma-fe;
    akkoma_admin_fe = admin-fe.packages.${system}.admin-fe;
    inherit fedibird_fe;
    tos = ./terms-of-service.html;
    dontUnpack = false;
    installPhase = ''
      mkdir -p $out/frontends/pleroma-fe/stable
      lndir $akkoma_fe $out/frontends/pleroma-fe/stable
      mkdir -p $out/frontends/admin-fe/stable
      lndir $akkoma_admin_fe $out/frontends/admin-fe/stable
      mkdir -p $out/frontends/fedibird-fe/akkoma
      lndir $fedibird_fe $out/frontends/fedibird-fe/akkoma
      ${toString (map copy_emoji_set emoji_set_names)}
      mkdir $out/emoji/misc
      ln -s ${./therian.png} $out/emoji/misc/therian.png
      mkdir $out/static
      cp $tos $out/static/terms-of-service.html
    '';
  };
  ec = pkgs.formats.elixirConf { };
  akkconfig = ec.generate "config.exs" (
    with ec.lib;
    {
      ":pleroma" = {
        "Pleroma.Upload" = {
          uploader = mkRaw "Pleroma.Uploaders.S3";
          filters = map (v: mkRaw ("Pleroma.Upload.Filter." + v)) [
            "Mogrify"
            "Dedupe"
            "AnonymizeFilename"
          ];
          base_url = "https://mastodon-assets.chir.rs/";
        };
        "Pleroma.Uploaders.S3" = {
          bucket = "mastodon-assets-chir-rs";
          truncated_namespace = "";
        };
        "Pleroma.Upload.Filter.Mogrify" = {
          args = [
            "auto-orient"
            "strip"
          ];
        };
        ":instance" = {
          name = "Raccoon Noises";
          email = "lotte@chir.rs";
          notify_email = "akko@chir.rs";
          description = "Small Akkoma Instance";
          limit = 58913;
          description_limit = 58913;
          upload_limit = 256 * 1024 * 1024;
          languages = [
            "en"
            "tok"
          ];
          invites_enabled = true;
          account_activation_required = true;
          account_approval_required = true;
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
        ":mrf_hellthread" = {
          delist_threshold = 8;
        };
        ":mrf_keyword" = {
          reject = [
            "usdtenm.com"
            (mkRaw "~r/Hi \\w+! New account: .* Do not share with anyone, official website:/i")
            "dogeai.farm"
            "ARB Doge"
            "new meme token created by the latest neural network"
            (mkRaw "~r/dogecoin.*airdrop/i")
            (mkRaw "~r/airdrop.*dogecoin/i")
          ];
        };
        ":mrf_simple" =
          let
            processMap =
              m:
              map (
                k:
                mkTuple [
                  k
                  m.${k}
                ]
              ) (builtins.attrNames m);
          in
          {
            reject = processMap {
              "qoto.org" = "Freeze Peach; Admin harasses other server admins; sends unsolicited emails";
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
              "feral.cafe" = "Zoophilia";
              "disqordia.space" = "No snooping!";
              "mastodon.cloud" = "Corporate instance; Owner engaged in scams";
              "mstdn.jp" = "Corporate instance; Owner engaged in scams";
              "pawoo.net" = "Corporate instance; Owner engaged in scams";
              "activitypub-proxy.cf" = "Block circumvention tool";
              "mapsupport.de" = "Pedophile instance";
              "pedo.school" = "Pedophile instance";
              "eientei.org" = "fash";
              "threads.net" =
                "owner was engaged, among other things, in monopolizing online information access in developing countries onto a platform that amplified unmoderated hate to a point where at least one genocide was committed.";
            };
            followers_only = processMap {
              "bird.makeup" = "Birdsite scraper with removed limitations and privacy considerations";
            };
            federated_timeline_removal = processMap {
              "mastodon.online" = "Too large to be moderated well";
              "tumblr.com" = "Too large to be moderated well, corporate instance";
              "vivaldi.net" = "Corporate instance; Registers nonconsensual accounts for Vivaldi Sync users";
              "mastodon.social" = "Too large to be moderated well";
            };
          };
        ":mrf" = {
          policies = map (v: mkRaw ("Pleroma.Web.ActivityPub.MRF." + v)) [
            "SimplePolicy"
            "EnsureRePrepended"
            "ForceBotUnlistedPolicy"
            "AntiFollowbotPolicy"
            "ObjectAgePolicy"
            "KeywordPolicy"
            "TagPolicy"
            "RequireImageDescription"
            "HellthreadPolicy"
          ];
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
          mastodon = mkMap {
            name = "fedibird-fe";
            ref = "akkoma";
          };
        };
        ":static_fe".enabled = true;
        ":media_proxy" = {
          enabled = true;
          base_url = "https://mediaproxy.chir.rs";
          proxy_opts = {
            redirect_on_failure = true;
          };
        };
        ":media_preview_proxy" = {
          enabled = true;
        };
        "Pleroma.Repo" = {
          adapter = mkRaw "Ecto.Adapters.Postgres";
          database = "akkoma";
          pool_size = 10;
          hostname = "localhost";
          port = 5432;
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
          shortcode_globs = [
            "/emoji/volpeon-blobfox-flip/*.png"
            "/emoji/volpeon-blobfox/*.png"
            "/emoji/volpeon-bunhd-flip/*.png"
            "/emoji/volpeon-bunhd/*.png"
            "/emoji/volpeon-drgn/*.png"
            "/emoji/volpeon-fox/*.png"
            "/emoji/volpeon-raccoon/*.png"
            "/emoji/volpeon-vlpn/*.png"
            "/emoji/lotte/*.png"
            "/emoji/caro/*.png"
            "/emoji/misc/*.png"
          ];
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
            "Caroline" = "/emoji/caro/*.png";
            "Misc" = "/emoji/misc/*.png";
          };
        };
        "Pleroma.Captcha" = {
          enabled = true;
          method = mkRaw "Pleroma.Captcha.Kocaptcha";
        };
      };
      ":web_push_encryption".":vapid_details".subject = "lotte@chir.rs";
      ":mime".":types" = mkMap {
        "application/activity+json" = [ "activity+json" ];
        "application/jrd+json" = [ "jrd+json" ];
        "application/ld+json" = [ "activity+json" ];
        "application/xml" = [ "xml" ];
        "application/xrd+xml" = [ "xrd+xml" ];
        "image/apng" = [ "apng" ];
      };

    }
  );
in
{
  services.pleroma = {
    enable = true;
    package = akkoma.packages.${system}.akkoma;
    configs = [
      ''
        import Config
        import_config "${akkconfig}"
      ''
    ];
    user = "akkoma";
    group = "akkoma";
    secretConfigFile = config.sops.secrets."services/akkoma.exs".path;
  };
  systemd.services.pleroma.path = with pkgs; [
    exiftool
    imagemagick
    ffmpeg
  ];
  services.postgresql = {
    extensions = ps: [ ps.rum ];
    ensureDatabases = [ "akkoma" ];
    ensureUsers = [
      {
        name = "akkoma";
        ensureDBOwnership = true;
      }
    ];
  };
  services.pgbouncer.settings.databases = {
    akkoma = "host=127.0.0.1 port=5432 auth_user=akkoma dbname=akkoma";
  };
  sops.secrets."services/akkoma.exs" = {
    sopsFile = ./secrets.yaml;
    owner = "akkoma";
  };
  services.caddy.virtualHosts."akko.chir.rs" = {
    useACMEHost = "chir.rs";
    extraConfig = ''
      import baseConfig
      handle /media_attachments/* {
        redir https://mastodon-assets.chir.rs{uri} permanent
      }
      @isbunny {
        header Via BunnyCDN
      }
      route /media/* {
        reverse_proxy @isbunny {
          header_down Content-Security-Policy "script-src 'none';"
          to http://127.0.0.1:4000
        }
        respond "Use the cdn" 403
      }
      route /proxy/* {
        reverse_proxy @isbunny {
          header_down Content-Security-Policy "script-src 'none';"
          to http://127.0.0.1:4000
        }
        respond "Use the cdn" 403
      }
      route {
        reverse_proxy {
          to http://127.0.0.1:4000
        }
      }
    '';
  };
}
