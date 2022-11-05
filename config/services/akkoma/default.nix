{
  pkgs,
  nix-packages,
  config,
  ...
}: let
  raccoon-emoji = pkgs.fetchzip {
    url = "https://volpeon.ink/art/emojis/raccoon/raccoon.zip";
    sha256 = "sha256-GkMiYAP0LS0TL6GMDG4R4FkGwFjhIwn3pAWUmCTUfHg=";
    stripRoot = false;
  };
  static_dir = pkgs.stdenvNoCC.mkDerivation {
    name = "akkoma-static";
    src = pkgs.emptyDirectory;
    nativeBuildInputs = with pkgs; [xorg.lndir];
    akkoma_fe = nix-packages.packages.${pkgs.system}.pleroma-fe;
    akkoma_admin_fe = nix-packages.packages.${pkgs.system}.admin-fe;
    raccoon_emoji = raccoon-emoji;
    tos = ./terms-of-service.html;
    dontUnpack = false;
    installPhase = ''
      mkdir -p $out/frontends/pleroma-fe/stable
      lndir $akkoma_fe $out/frontends/pleroma-fe/stable
      mkdir -p $out/frontends/admin-fe/stable
      lndir $akkoma_admin_fe $out/frontends/admin-fe/stable
      mkdir -p $out/emoji/raccoons
      lndir $raccoon_emoji $out/emoji/raccoons
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
      ":activitypub".authorized_fetch_mode = true;
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
      "Pleroma.Repo" = {
        adapter = mkRaw "Ecto.Adapters.Postgres";
        database = "akkoma";
        pool_size = 10;
        socket_dir = "/run/postgresql";
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
      "Pleroma.Web.Plugs.RemoteIp" = {
        enabled = true;
        proxies = ["127.0.0.1" "[::1]" "[fd0d:a262:1fa6:e621:b4e1:8ff:e658:6f49]"];
      };
    };
    ":web_push_encryption".":vapid_details".subject = "lotte@chir.rs";
  });
in {
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
      handle {
        reverse_proxy {
          to http://127.0.0.1:4000
        }
      }
    '';
  };
}
