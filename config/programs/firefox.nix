{ pkgs, ... }: {
  programs.firefox = {
    enable = true;
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      decentraleyes
      onepassword-password-manager
      privacy-badger
      sponsorblock
      stylus
      tree-style-tab
      ublock-origin
    ];
    profiles = {
      lotte = {
        settings = {
          # I have yet to find a website that has a genuine reason for me to allow notifs
          "dom.webnotifications.enabled" = false;
          # Prevent JavaScript from profiling (high-resolution) performance or timing
          "dom.enable_performance" = false;
          "dom.enable_resource_timing" = false;
          "dom.enable_user_timing" = false;
          # Disable geolocation
          "geo.enabled" = false;
          # Use mozilla’s geoinformation instead of google’s
          "geo.wifi.uri" = "https://location.services.mozilla.com/v1/geolocate?key=%MOZILLA_API_KEY%";
          # Don’t log geoinformation
          "geo.wifi.logging.enabled" = false;
          # Disable WebTelephony
          "dom.telephony.enabled" = false;
          # Disable beacons (used for analytics)
          "beacon.enabled" = false;
          # Disable sensors API
          "device.sensors.enabled" = false;
          # Disable a pings 
          "browser.send_pings" = false;
          # Prevent USB device enumeration
          "dom.gamepad.enabled" = false;
          # Disable VR
          "dom.vr.enabled" = false;
          # Disable vibration api
          "dom.vibrator.enabled" = false;
          # Disable face detection 
          "camera.control.face_detection.enabled" = false;
          # Set search engine region to US
          "browser.search.countryCode" = "US";
          "browser.search.region" = "US";
          "browser.search.geoip.url" = "";
          # Set Accept-Language to en-US
          "intl.accept_languages" = "en-US, en";
          # Don’t use the host locale
          "intl.locale.matchOS" = false;
          # Don’t use geo-specific search engines
          "browser.search.geoSpecificDefaults" = false;
          # Use US locale in javascript
          "javascript.use_us_english_locale" = true;
          # Don’t submit invalid urls to the search engine
          "keyword.enabled" = false;
          # Don’t guess domain names
          "browser.fixup.alternate.enabled" = false;
          # Send DNS queries through SOCKS
          "network.proxy.socks_remote_dns" = true;
          # Block mixed content
          "security.mixed_content.block_active_content" = true;
          "security.mixed_content.block_display_content" = true;
          # Don’t open unsafe types in jars
          "network.jar.open-unsafe-types" = false;
          # File URI origin policy
          "security.fileuri.strict_origin_policy" = true;
          # Filter javascript from history
          "browser.urlbar.filter.javascript" = true;
          # Disable video stats 
          "media.video_stats.enabled" = false;
          # Don’t reveal buildID
          "general.buildID.override" = "20100101";
          "browser.startup.homepage_override.buildID" = "20100101";
          # Don’t use document-enumerated fonts
          "browser.display.use_document_fonts" = false;
          # Disable extension recommendations 
          "browser.newtabpage.activity-stream.asrouter.userprefs.cfr" = false;
          # Disable WebIDE
          "devtools.webide.enabled" = false;
          "devtools.webide.autoinstallADBHelper" = false;
          "devtools.webide.autoinstallFxdtAdapters" = false;
          # Disable remote debugging
          "devtools.debugger.remote-enabled" = false;
          "devtools.debugger.force-local" = true;
          # Disable telemetry and experiments
          "toolkit.telemetry.enabled" = false;
          "toolkit.telemetry.unified" = false;
          "toolkit.telemetry.archive.enabled" = false;
          "experiments.supported" = false;
          "experiments.enabled" = false;
          "experiments.manifest.uri" = "";
          # Disable Necko A/B testing
          "network.allow-experiments" = false;
          # Disable crash reports 
          "breakpad.reportURL" = "";
          "browser.tabs.crashReporting.sendReport" = false;
          "browser.crashReports.unsubmittedCheck.enabled" = false;
          # Disable IOT discovery
          "dom.flyweb.enabled" = false;
          # Enable Tracking protection
          "privacy.trackingprotection.enabled" = true;
          "privacy.trackingprotection.pbmode.enabled" = true;
          # Enable contextual identity containers
          "privacy.userContext.enabled" = true;
          # Resist fingerprinting
          "privacy.resistFingerprinting" = true;
          # Disable mozAddonManager api
          "privacy.resistFingerprinting.block_mozAddonManager" = true;
          "extensions.webextensions.restrictedDomains" = "";
          # Disable health report
          "datareporting.healthreport.uploadEnabled" = false;
          "datareporting.healthreport.service.enabled" = false;
          "datareporting.policy.dataSubmissionEnabled" = false;
          # Disable personalized extension recommendations
          "browser.discovery.enabled" = false;
          # Disable telemetry
          "app.normandy.enabled" = false;
          "app.normandy.api_url" = "";
          "extensions.shield-recipe-client.enabled" = false;
          "app.shield.optoutstudies.enabled" = false;
          # Enable safe browsing
          "browser.safebrowsing.phishing.enabled" = true;
          "browser.safebrowsing.malware.enabled" = true;
          # Disable the use of google’s application reputation database
          "browser.safebrowsing.downloads.remote.enabled" = false;
          # Disable pocket 
          "browser.pocket.enabled" = false;
          "extensions.pocket.enabled" = false;
          "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
          # Disable automatic connections
          "network.prefetch-next" = false;
          "network.dns.disablePrefetch" = true;
          "network.dns.disablePrefetchFromHTTPS" = true;
          "network.predictor.enabled" = false;
          "network.dns.blockDotOnion" = true;
          "browser.search.suggest.enabled" = false;
          "browser.urlbar.groupLabels.enabled" = false;
          "browser.casting.enabled" = false;
          "media.gmp-gmpopenh264.enabled" = false;
          "media.gmp-manager.url" = "";
          "network.http.speculative-parallel-limit" = 0;
          "browser.aboutHomeSnippets.updateUrl" = "";
          "browser.search.update" = false;
          "network.captive-portal-service.enabled" = false;
          # Disable NTLMv1
          "network.negotiate-auth.allow-insecure-ntlm-v1" = false;
          # Enable CSP 1.1 script-nonce
          "security.csp.experimentalEnabled" = true;
          # Enable CSP
          "security.csp.enable" = true;
          # Enable SRI
          "security.sri.enable" = true;
          # Spoof referrer header 
          "network.http.referer.spoofSource" = true;
          # Disable cross-origin referrer headers
          "network.http.referer.XOriginPolicy" = 2;
          # block 3rd party cookies
          "network.cookie.cookieBehavior" = 1;
          # 1st party isolation
          "privacy.firstparty.isolate" = true;
          # Enable HTTPS only mode
          "dom.security.https_only_mode" = true;
          # Preload HSTS
          "network.stricttransportsecurity.preloadlist" = true;
          # enable OCSP
          "security.OCSP.enabled" = 1;
          "security.ssl.enable_ocsp_stapling" = true;
          "security.ssl.enable_ocsp_must_staple" = true;
          "security.OCSP.require" = true;
          # Disable session tickets
          "security.ssl.disable_session_identifiers" = true;
          # Require the server to be updated
          "security.tls.version.min" = 3;
          "security.tls.version.max" = 4;
          # Disable insecure fallback
          "security.tls.version.fallback-limit" = 4;
          # Enforce public key pinning 
          "security.cert_pinning.enforcement_level" = 2;
          # Disallow sha-1
          "security.pki.sha1_enforcement_level" = 1;
          # unsafe negotiation = broken 
          "security.ssl.treat_unsafe_negotiation_as_broken" = true;
          # Disable error reporting
          "security.ssl.errorReporting.automatic" = false;
          "browser.ssl_override_behavior" = 1;
          # use ESNI 
          "network.security.esni.enabled" = true;
        };

        userChrome = ''
          /* Hide tab bar in FF Quantum */
          @-moz-document url("chrome://browser/content/browser.xul") {
            #TabsToolbar {
              visibility: collapse !important;
              margin-bottom: 21px !important;
            }

            #sidebar-box[sidebarcommand="treestyletab_piro_sakura_ne_jp-sidebar-action"] #sidebar-header {
              visibility: collapse !important;
            }
          }
        '';
      };
    };
  };
}
