import Config

config :pleroma, Pleroma.Upload,
  uploader: Pleroma.Uploaders.S3,
  filters: [
    Pleroma.Upload.Filter.Mogrify,
    Pleroma.Upload.Filter.Exiftool,
    Pleroma.Upload.Filter.Dedupe,
    Pleroma.Upload.Filter.AnonymizeFilename
  ],
  base_url: "https://mastodon-assets.chir.rs/"

config :pleroma, Pleroma.Uploaders.S3,
  bucket: "mastodon-chir-rs",
  truncated_namespace: ""

config :pleroma, Pleroma.Upload.Filter.Mogrify,
  args: "auto-orient"

config :pleroma, :instance,
  name: "Raccoon Noises",
  email: "lotte@chir.rs",
  notify_email: "akkoma@chir.rs",
  description: "Single User Akkoma Instance",
  limit: 0xe621,
  description_limit: 0xe621,
  upload_limit: 100_000_000,
  languages: ["en", "tok"],
  registrations_open: false,
  static_dir: "%AKKOMA_STATIC_DIR%",
  max_pinned_statuses: 10,
  attachment_links: true,
  max_report_comment_size: 0xe621,
  safe_dm_mentions: true,
  healthcheck: true,
  user_bio_length: 0xe621,
  user_name_length: 621,
  max_account_fields: 69,
  max_remote_account_fields: 621,
  account_field_name_length: 621,
  account_field_value_length: 0xe621,
  registration_reason_length: 621,
  external_user_synchronization: true,
  cleanup_attachments: true

config :pleroma, :markup,
  allow_headings: true,
  allow_tables: true,
  allow_fonts: true

config :pleroma, :frontend_configurations,
  pleroma_fe: %{
    webPushNotifications: true
  }

config :pleroma, :activitypub,
  authorized_fetch_mode: true

config :pleroma, :mrf_simple,
  reject: [
    {"qoto.org", "Freeze Peach"},
    {"poa.st", "Hosting neonazis"},
    {"kiwifarms.cc", "Targeted Harassment"},
    {"pmth.us", "Harassment"},
    {"nicecrew.digital", "TERF Instance"},
    {"freespeechextremist.com", "Freeze Peach"},
    {"ryona.agency", "Freeze Peach"},
    {"howlr.me", "Owner was verified kiwifarms user, engages in harassment"}
  ],
  media_removal: [
    {"a.rathersafe.space", "posting borderline illegal imagery as the fediblock account"}
  ]

config :pleroma, :mrf,
  policies: [
    Pleroma.Web.ActivityPub.MRF.SimplePolicy,
    Pleroma.Web.ActivityPub.MRF.EnsureRePrepended,
    Pleroma.Web.ActivityPub.MRF.MediaProxyWarmingPolicy,
    Pleroma.Web.ActivityPub.MRF.ForceBotUnlistedPolicy,
    Pleroma.Web.ActivityPub.MRF.AntiFollowbotPolicy,
    Pleroma.Web.ActivityPub.MRF.ObjectAgePolicy,
    Pleroma.Web.ActivityPub.MRF.TagPolicy,
    Pleroma.Web.ActivityPub.MRF.RequireImageDescription
  ],
  transparency: true

#config :pleroma, :media_proxy,
#  enable: true

#config :pleroma, :media_preview_proxy,
#  enable: true

config :pleroma, :http_security,
  sts: true

config :pleroma, :frontends,
  primary: %{
    "name" => "pleroma-fe",
    "ref" => "stable"
  },
  admin: %{
    "name" => "admin-fe",
    "ref" => "stable"
  }

config :web_push_encryption, :vapid_details,
  subject: "lotte@chir.rs"

config :pleroma, Pleroma.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "akkoma",
  pool_size: 10,
  socket_dir: "/run/postgresql"

config :pleroma, Pleroma.Web.Endpoint,
  url: [host: "akko.chir.rs", port: 443, scheme: "https"]
