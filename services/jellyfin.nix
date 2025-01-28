{ lib, pkgs, ... }:
{
  services.jellyfin.enable = true;
  environment.systemPackages = [
    pkgs.jellyfin
    pkgs.jellyfin-web
    pkgs.jellyfin-ffmpeg
    pkgs.yt-dlp
  ];
  systemd.services.jellyfin.path = [ pkgs.yt-dlp ];
  services.caddy.virtualHosts."jellyfin.int.chir.rs" = {
    useACMEHost = "int.chir.rs";
    logFormat = pkgs.lib.mkForce "";
    extraConfig = ''
      import baseConfig

      reverse_proxy {
        to http://localhost:8096
        trusted_proxies private_ranges
      }
    '';
  };
  systemd.services.update-youtube = {
    description = "Update YouTube subscriptions";
    restartIfChanged = false;
    unitConfig.X-StopOnRemoval = false;

    requires = [ "network-online.target" ];
    after = [ "network-online.target" ];
    serviceConfig.Type = "oneshot";
    script = ''
      #!${lib.getExe pkgs.bash}
      cd /media/Youtube
      ${lib.getExe pkgs.yt-dlp} -4 --playlist-end 25 --format "(bestvideo[vcodec^=av01][height>=4320][fps>30]/bestvideo[vcodec^=vp09.02][height>=4320][fps>30]/bestvideo[vcodec^=vp09.00][height>=4320][fps>30]/bestvideo[vcodec^=vp9][height>=4320][fps>30]/bestvideo[vcodec^=avc1][height>=4320][fps>30]/bestvideo[height>=4320][fps>30]/bestvideo[vcodec^=av01][height>=4320]/bestvideo[vcodec^=vp09.02][height>=4320]/bestvideo[vcodec^=vp09.00][height>=4320]/bestvideo[vcodec^=vp9][height>=4320]/bestvideo[vcodec^=avc1][height>=4320]/bestvideo[height>=4320]/bestvideo[vcodec^=av01][height>=2880][fps>30]/bestvideo[vcodec^=vp09.02][height>=2880][fps>30]/bestvideo[vcodec^=vp09.00][height>=2880][fps>30]/bestvideo[vcodec^=vp9][height>=2880][fps>30]/bestvideo[vcodec^=avc1][height>=2880][fps>30]/bestvideo[height>=2880][fps>30]/bestvideo[vcodec^=av01][height>=2880]/bestvideo[vcodec^=vp09.02][height>=2880]/bestvideo[vcodec^=vp09.00][height>=2880]/bestvideo[vcodec^=vp9][height>=2880]/bestvideo[vcodec^=avc1][height>=2880]/bestvideo[height>=2880]/bestvideo[vcodec^=av01][height>=2160][fps>30]/bestvideo[vcodec^=vp09.02][height>=2160][fps>30]/bestvideo[vcodec^=vp09.00][height>=2160][fps>30]/bestvideo[vcodec^=vp9][height>=2160][fps>30]/bestvideo[vcodec^=avc1][height>=2160][fps>30]/bestvideo[height>=2160][fps>30]/bestvideo[vcodec^=av01][height>=2160]/bestvideo[vcodec^=vp09.02][height>=2160]/bestvideo[vcodec^=vp09.00][height>=2160]/bestvideo[vcodec^=vp9][height>=2160]/bestvideo[vcodec^=avc1][height>=2160]/bestvideo[height>=2160]/bestvideo[vcodec^=av01][height>=1440][fps>30]/bestvideo[vcodec^=vp09.02][height>=1440][fps>30]/bestvideo[vcodec^=vp09.00][height>=1440][fps>30]/bestvideo[vcodec^=vp9][height>=1440][fps>30]/bestvideo[vcodec^=avc1][height>=1440][fps>30]/bestvideo[height>=1440][fps>30]/bestvideo[vcodec^=av01][height>=1440]/bestvideo[vcodec^=vp09.02][height>=1440]/bestvideo[vcodec^=vp09.00][height>=1440]/bestvideo[vcodec^=vp9][height>=1440]/bestvideo[vcodec^=avc1][height>=1440]/bestvideo[height>=1440]/bestvideo[vcodec^=av01][height>=1080][fps>30]/bestvideo[vcodec^=vp09.02][height>=1080][fps>30]/bestvideo[vcodec^=vp09.00][height>=1080][fps>30]/bestvideo[vcodec^=vp9][height>=1080][fps>30]/bestvideo[vcodec^=avc1][height>=1080][fps>30]/bestvideo[height>=1080][fps>30]/bestvideo[vcodec^=av01][height>=1080]/bestvideo[vcodec^=vp09.02][height>=1080]/bestvideo[vcodec^=vp09.00][height>=1080]/bestvideo[vcodec^=vp9][height>=1080]/bestvideo[vcodec^=avc1][height>=1080]/bestvideo[height>=1080]/bestvideo[vcodec^=av01][height>=720][fps>30]/bestvideo[vcodec^=vp09.02][height>=720][fps>30]/bestvideo[vcodec^=vp09.00][height>=720][fps>30]/bestvideo[vcodec^=vp9][height>=720][fps>30]/bestvideo[vcodec^=avc1][height>=720][fps>30]/bestvideo[height>=720][fps>30]/bestvideo[vcodec^=av01][height>=720]/bestvideo[vcodec^=vp09.02][height>=720]/bestvideo[vcodec^=vp09.00][height>=720]/bestvideo[vcodec^=vp9][height>=720]/bestvideo[vcodec^=avc1][height>=720]/bestvideo[height>=720]/bestvideo[vcodec^=av01][height>=480][fps>30]/bestvideo[vcodec^=vp09.02][height>=480][fps>30]/bestvideo[vcodec^=vp09.00][height>=480][fps>30]/bestvideo[vcodec^=vp9][height>=480][fps>30]/bestvideo[vcodec^=avc1][height>=480][fps>30]/bestvideo[height>=480][fps>30]/bestvideo[vcodec^=av01][height>=480]/bestvideo[vcodec^=vp09.02][height>=480]/bestvideo[vcodec^=vp09.00][height>=480]/bestvideo[vcodec^=vp9][height>=480]/bestvideo[vcodec^=avc1][height>=480]/bestvideo[height>=480]/bestvideo[vcodec^=av01][height>=360][fps>30]/bestvideo[vcodec^=vp09.02][height>=360][fps>30]/bestvideo[vcodec^=vp09.00][height>=360][fps>30]/bestvideo[vcodec^=vp9][height>=360][fps>30]/bestvideo[vcodec^=avc1][height>=360][fps>30]/bestvideo[height>=360][fps>30]/bestvideo[vcodec^=av01][height>=360]/bestvideo[vcodec^=vp09.02][height>=360]/bestvideo[vcodec^=vp09.00][height>=360]/bestvideo[vcodec^=vp9][height>=360]/bestvideo[vcodec^=avc1][height>=360]/bestvideo[height>=360]/bestvideo[vcodec^=avc1][height>=240][fps>30]/bestvideo[vcodec^=av01][height>=240][fps>30]/bestvideo[vcodec^=vp09.02][height>=240][fps>30]/bestvideo[vcodec^=vp09.00][height>=240][fps>30]/bestvideo[vcodec^=vp9][height>=240][fps>30]/bestvideo[height>=240][fps>30]/bestvideo[vcodec^=avc1][height>=240]/bestvideo[vcodec^=av01][height>=240]/bestvideo[vcodec^=vp09.02][height>=240]/bestvideo[vcodec^=vp09.00][height>=240]/bestvideo[vcodec^=vp9][height>=240]/bestvideo[height>=240]/bestvideo[vcodec^=avc1][height>=144][fps>30]/bestvideo[vcodec^=av01][height>=144][fps>30]/bestvideo[vcodec^=vp09.02][height>=144][fps>30]/bestvideo[vcodec^=vp09.00][height>=144][fps>30]/bestvideo[vcodec^=vp9][height>=144][fps>30]/bestvideo[height>=144][fps>30]/bestvideo[vcodec^=avc1][height>=144]/bestvideo[vcodec^=av01][height>=144]/bestvideo[vcodec^=vp09.02][height>=144]/bestvideo[vcodec^=vp09.00][height>=144]/bestvideo[vcodec^=vp9][height>=144]/bestvideo[height>=144]/bestvideo)+(bestaudio[acodec^=opus]/bestaudio)/best" --verbose --sleep-requests 1 --sleep-interval 5 --max-sleep-interval 30 --extractor-retries 10 --retry-sleep 60 --ignore-errors --no-continue --no-overwrites --download-archive archive.log --add-metadata --parse-metadata "%(title)s:%(meta_title)s" --parse-metadata "%(uploader)s:%(meta_artist)s" --sponsorblock-remove sponsor --write-description --write-info-json --write-annotations --write-thumbnail --embed-thumbnail --sub-langs en --write-auto-sub --embed-subs --check-formats --concurrent-fragments 3 --match-filter "!is_live & !live & !was_live" --output "%(uploader)s/Season 00/%(title)s - %(uploader)s - %(upload_date)s [%(id)s].%(ext)s" --convert-subtitles ass --merge-output-format "mkv" --batch-file "source.txt" 2>&1 | tee output.log
    '';
    serviceConfig.User = "jellyfin";
    serviceConfig.Group = "jellyfin";
  };
  systemd.timers.update-youtube = {
    description = "Automatically update YouTube subscriptions";
    requires = [
      "update-youtube.service"
      "network-online.target"
    ];
    after = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    timerConfig = {
      OnBootSec = "30m";
      OnUnitActiveSec = "12h";
      RandomizedDelaySec = "24h";
    };
  };
}
