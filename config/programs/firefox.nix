{ pkgs, ... }: {
  programs.firefox = {
    enable = true;
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      canvasblocker
      clearurls
      consent-o-matic
      darkreader
      decentraleyes
      don-t-fuck-with-paste
      i-dont-care-about-cookies
      keepassxc-browser
      privacy-badger
      privacy-possum
      sponsorblock
      stylus
      tree-style-tab
      ublock-origin
      umatrix
      unpaywall
    ];
    profiles = {
      unhardened = {
        id = 1;
      };
      default = {
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
        settings = {
          # From https://github.com/pyllyukko/user.js/blob/master/user.js
          "dom.serviceWorkers.enabled" = false; # Disable service workers
          "dom.webnotifications.enabled" = false; # Disable notifications
          "dom.enable_performance" = false; # Disable DOM timing API
          "dom.enable_resource_timing" = false; # Disable resource timing API
          "dom.enable_user_timing" = false; # Disable user timing API
          "dom.webaudio.enabled" = false; # Disable Web Audio API
          "geo.enabled" = false; # Disable Geolocation
          "geo.wifi.uri" = "https://location.services.mozilla.com/v1/geolocate?key=%MOZILLA_API_KEY%"; # Use Mozilla geolocation service
          "geo.wifi.logging.enabled" = false; # Disable logging for wifi geolocation
          "dom.mozTCPSocket.enabled" = false; # Disable raw TCP sockets
          "dom.netinfo.enabled" = false; # Disable network information API
          "dom.network.enabled" = false; # Disable network API
          "media.peerconnection.ice.no_host" = true; # Don’t leak internal IP addresses
          "dom.battery.enabled" = false; # Disable battery API
          "dom.telephony.enabled" = false; # Disable telephony API
          "beacon.enabled" = false; # Disable analytics bs
          "dom.event.clipboardevents.enabled" = false; # Disable clipboard events
          "dom.allow_cut_copy" = false; # Disable cut/copy javascript
          "media.webspeech.recognition.enable" = false; # Disable speech recognition
          "media.webspeech.synth.enabled" = false; # Disable speech synthesis
          "device.sensors.enabled" = false; # Disable device sensors
          "browser.send_pings" = false; # Disable analytics bs
          "browser.send_pings.require_same_host" = true; # If enabled, only allow same host
          "dom.gamepad.enabled" = false; # Prevent USB device enumeration
          "dom.vr.enabled" = false; # Disable VR
          "dom.vibrator.enabled" = false; # Disable vibrator
          "dom.archivereader.enabled" = false; # Disable archive reader
          "webgl.disabled" = true; # Disable WebGL
          "webgl.min_capability_mode" = true; # If webgl is enabled, use the minimum capability mode
          "webgl.disable-extensions" = true; # If webgl is enabled, disable extensions
          "webgl.disable-fail-if-major-performance-caveat" = true; # If webgl is enabled, disable the fail-if-major-performance-caveat mode
          "webgl.enable-debug-renderer-info" = false; # If webgl is enabled, disable the debug renderer info
          "dom.maxHardwareConcurrency" = 2; # Spoof dual-core CPU
          "camera.control.face_detection.enabled" = false; # Disable face detection
          "browser.search.countryCode" = "US"; # Set default search country
          "browser.search.region" = "US"; # Set default search region
          "browser.search.geoip.url" = "";
          "intl.accept_languages" = "en-US,en"; # Set default language
          "intl.locale.matchOS" = false; # Disable OS language matching
          "browser.search.geoSpecificDefaults" = false; # Disable geolocation-based search defaults
          "clipboard.autocopy" = false; # Disable autocopy
          "javascript.use_us_english_locale" = true; # Force US English locale
          "browser.urlbar.trimURLs" = false; # Disable URL trimming
          "browser.fixup.alternate.enabled" = false; # Don’t try to guess domain names
          "browser.fixup.hide_user_pass" = true; # Hide passwords in URLs
          "network.proxy.socks_remote_dns" = true; # Enable remote DNS
          "network.manage-offline-status" = false; # Disable offline status management
          "security.mixed_content.block_active_content" = true; # Block mixed content
          "security.mixed_content.block_display_content" = true; # Block mixed content
          "network.jar.open-unsafe-types" = false; # Disable opening of unsafe types
          "security.xpconnect.plugin.unrestricted" = false;
          "security.fileuri.strict_origin_policy" = true; # Strict origin policy for file URIs
          "browser.urlbar.filter.javascript" = true; # Disable displaying javascript in history urls
          "media.video_stats.enabled" = false; # Disable video stats
          "general.buildID.override" = "20100101"; # Force Firefox build ID
          "browser.startup.homepage_override.buildID" = "20100101"; # Force Firefox build ID
          "browser.display.use_document_fonts" = 0; # Disable document fonts
          "security.dialog_enable_delay" = 1000; # Add addon install delay
          "extensions.getAddons.cache.enabled" = false; # No add-on metadata updates
          "lightweightThemes.update.enabled" = false; # Disable lightweight themes
          "plugin.state.flash" = 0; # Disable Flash
          "plugin.state.java" = 0; # Disable Java
          "dom.ipc.plugins.subprocess.crashreporter.enabled" = false; # Disable Flash crash reporting
          "dom.ipc.plugins.reportCrashURL" = false; # Disable Flash crash reporting
          "browser.safebrowsing.blockedURIs.enabled" = true; # download and use the mozilla blocklist
          "plugins.click_to_play" = true; # Enable click-to-play for plugins
          "extensions.update.enabled" = true; # Enable extension updates
          "extensions.blocklist.enabled" = true; # Enable extension blocklisting
          "services.blocklist.update_enabled" = true; # Enable blocklisting updates
          "extensions.blocklist.url" = "https://addons.mozilla.org/blocklist/3/%APP_ID%/%APP_VERSION%/"; # Set blocklist URL
          "browser.newtabpage.activity-stream.asrouter.userprefs.cfr" = false; # Disable Extension recommendations
          "devtools.webide.enabled" = false; # Disable WebIDE
          "devtools.webide.autoinstallADBHelper" = false; # Disable WebIDE ADB helper
          "devtools.webide.autoinstallFxdtAdapters" = false; # Disable WebIDE ADB helper
          "devtools.debugger.remote-enabled" = false; # Disable remote debugging
          "devtools.chrome.enabled" = false; # Disable remote debugging
          "devtools.debugger.force-local" = true; # Disable remote debugging
          "toolkit.telemetry.enabled" = false; # Disable Telemetry
          "toolkit.telemetry.unified" = false; # Disable Telemetry
          "toolkit.telemetry.archive.enabled" = false; # Disable Telemetry
          "experiments.supported" = false; # Disable experiments
          "experiments.enabled" = false; # Disable experiments
          "experiments.manifest.uri" = ""; # Disable experiments
          "breakpad.reportURL" = ""; # Disable breakpad
          "browser.tabs.crashReporting.sendReport" = false; # Disable crash reporting
          "browser.crashReports.unsubmittedCheck.enabled" = false; # Disable crash reporting
          "dom.flyweb.enabled" = false; # Disable FlyWeb
          "browser.uitour.enabled" = false; # Disable uitour
          "privacy.trackingprotection.enabled" = true; # Enable tracking protection
          "privacy.trackingprotection.pbmode.enabled" = true; # Enable tracking protection
          "privacy.userContext.enabled" = true; # Enable user context
          "privacy.resistFingerprinting" = true; # Enable fingerprinting resistance
          "privacy.resistFingerprinting.block_mozAddonManager" = true; # Enable fingerprinting resistance
          "extensions.webextensions.restrictedDomains" = "";
          "browser.startup.blankWindow" = true; # Start up to about:blank
          "datareporting.healthreport.uploadEnabled" = false; # Disable health reports
          "datareporting.healthreport.service.enabled" = false; # Disable health reports
          "datareporting.policy.dataSubmissionEnabled" = false; # Disable health reports
          "browser.discovery.enabled" = false; # Disable discovery
          "app.normandy.enabled" = false; # Disable Normandy
          "app.normandy.api_url" = ""; # Disable Normandy
          "extensions.shield-recipe-client.enabled" = false; # Disable Shield
          "app.shield.optoutstudies.enabled" = false; # Disable Shield
          "loop.logDomains" = false; # Disable Firefox Hello metrics collection
          "browser.safebrowsing.phishing.enabled" = true; # Enable phishing detection
          "browser.safebrowsing.malware.enabled" = true; # Enable malware detection
          "browser.safebrowsing.downloads.remote.enabled" = false; # Disable application reputation
          "browser.pocket.enabled" = false; # Disable Pocket
          "extensions.pocket.enabled" = false; # Disable Pocket
          "browser.newtabpage.activity-stream.feeds.sections.topstories" = false; # Disable Pocket
          "network.prefetch-next" = false; # Disable prefetching
          "network.dns.disablePrefetch" = true; # Disable prefetching
          "network.dns.disablePrefetchFromHTTPS" = true; # Disable prefetching
          "network.predictor.enabled" = false; # Disable predictive actions
          "network.dns.blockDotOnion" = true; # Disable dns lookups for dot onion domains
          "browser.search.suggest.enabled" = false; # Disable search suggestions
          "browser.urlbar.suggest.searches" = false; # Disable search suggestions
          "browser.urlbar.suggest.history" = false; # Disable history suggestions
          "browser.urlbar.groupLabels.enabled" = false; # Disable firefox suggest
          "browser.casting.enabled" = false; # Disable casting
          "media.gmp-gmpopenh264.enabled" = false; # Disable H264 codec
          "media.gmp-manager.url" = ""; # Disable H264 codec
          "network.http.speculative-parallel-limit" = 0; # Disable speculative parallel requests
          "browser.aboutHomeSnippets.updateUrl" = ""; # Disable snippets
          "browser.search.update" = false; # Disable search updates
          "network.captive-portal-service.enabled" = false; # Disable captive portal
          "network-negotiate-auth.allow-insecure-ntlm-v1" = false; # Disable NTLM
          "security.csp.experimentalEnabled" = true; # Enable CSP 1.1 script-nonce directive support
          "security.csp.enable" = true; # Enable CSP 1.1
          "security.sri.enable" = true; # Enable SRI
          "network.http.referer.spoofSource" = true; # Enable referer spoofing
          "network.http.referer.XOriginPolicy" = 2; # Enable referer spoofing
          "network.cookie.cookieBehavior" = 1; # Only allow 1st-party cookies
          "privacy.firstparty.isolate" = true; # Enable 1st-party isolation
          "network.cookie.thirdparty.sessionOnly" = true; # Never persist 3rd-party cookies
          "privacy.sanitize.sanitizeOnShutdown" = true; # Clear cookies on shutdown
          "privacy.clearOnShutdown.cache" = true; # Clear cache on shutdown
          "privacy.clearOnShutdown.cookies" = true; # Clear cookies on shutdown
          "privacy.clearOnShutdown.downloads" = true; # Clear downloads on shutdown
          "privacy.clearOnShutdown.formdata" = true; # Clear form data on shutdown
          "privacy.clearOnShutdown.history" = true; # Clear history on shutdown
          "privacy.clearOnShutdown.offlineApps" = true; # Clear offline apps on shutdown
          "privacy.clearOnShutdown.sessions" = true; # Clear sessions on shutdown
          "privacy.clearOnShutdown.openWindows" = true; # Clear open windows on shutdown
          "privacy.sanitize.timeSpan" = 0; # Clear everything when clearing history
          "privacy.cpd.offlineApps" = true; # Clear offline apps when clearing recent history
          "privacy.cpd.cache" = true; # Clear cache when clearing recent history
          "privacy.cpd.cookies" = true; # Clear cookies when clearing recent history
          "privacy.cpd.downloads" = true; # Clear downloads when clearing recent history
          "privacy.cpd.formdata" = true; # Clear form data when clearing recent history
          "privacy.cpd.history" = true; # Clear history when clearing recent history
          "privacy.cpd.sessions" = true; # Clear sessions when clearing recent history
          "places.history.enabled" = false; # Disable history
          "browser.download.manager.retention" = 0; # Disable download manager
          "signon.rememberSignons" = false; # Disable password manager
          "browser.formfill.enable" = false; # Disable form autofill
          "network.cookie.lifetimePolicy" = 2; # Make all cookies temporary
          "signon.autofillForms" = false; # Disable autofill
          "signon.formlessCapture.enabled" = false; # Disable formless login capture
          "signon.autofillForms.http" = false; # Disable autofill
          "security.insecure_field_warning.contextual.enabled" = true; # Enable contextual insecure warnings
          "browser.formfill.expire_days" = 0; # Disable form autofill
          "browser.sessionstore.privacy_level" = 2; # Disable session data
          "browser.sessionstore.resume_from_crash" = false; # Disable session data
          "browser.helperApps.deleteTempFileOnExit" = true; # Delete temporary files on exit
          "browser.pagethumbnails.capturing_disabled" = true; # Disable thumbnails
          "browser.shell.shortcutFavicons" = false; # Disable favicons
          "browser.bookmarks.max_backups" = 0; # Disable bookmarks backups
          "browser.chrome.site_icons" = false; # Disable site icons
          "security.insecure_password.ui.enabled" = true; # Enable insecure password warnings
          "browser.newtabpage.enabled" = false; # Disable new tab page
          "browser.newtab.url" = "about:blank"; # Disable new tab page
          "browser.newtabpage.activity-stream.enabled" = false; # Disable new tab page
          "browser.newtabpage.enhanced" = false; # Disable new tab page
          "browser.newtab.preload" = false; # Disable new tab page
          "browser.newtabpage.directory.ping" = ""; # Disable new tab page
          "browser.newtabpage.directory.source" = "data:text/plain,{}"; # Disable new tab page
          "plugins.update.notifyUser" = true; # Enable plugin notifications
          "network.IDN_show_punycode" = true; # Show IDN in Unicode
          "browser.urlbar.autoFill" = false; # Disable urlbar autocomplete
          "browser.urlbar.autoFill.typed" = false; # Disable urlbar autocomplete
          "layout.css.visited_links_enabled" = false; # Disable visited links
          "browser.urlbar.autocomplete.enabled" = false; # Disable urlbar autocomplete
          "browser.shell.checkDefaultBrowser" = false; # Disable default browser check
          "browser.offline-apps.notify" = false; # Disable offline app notifications
          "dom.security.https_only_mode" = true; # Enable https-only mode
          "network.stricttransportsecurity.preloadlist" = true; # Enable HSTS preload list
          "security.OCSP.enabled" = 1;
          "security.ssl.enable_ocsp_stapling" = true;
          "security.ssl.enable_ocsp_must_staple" = true;
          "security.OCSP.require" = true;
          "security.ssl.disable_session_identifiers" = true;
          "security.tls.version.min" = 3;
          "security.tls.version.max" = 4;
          "security.tls.version.fallback-limit" = 4;
          "security.cert_pinning.enforcement_level" = 2;
          "security.pki.sha1_enforcement_level" = 1;
          "security.ssl.treat_unsafe_negotiation_as_broken" = true;
          "security.ssl.errorReporting.automatic" = false;
          "browser.ssl_override_behavior" = 1;
          "network.security.esni.enabled" = true;
          "security.ssl3.rsa_null_sha" = false;
          "security.ssl3.rsa_null_md5" = false;
          "security.ssl3.ecdhe_rsa_null_sha" = false;
          "security.ssl3.ecdhe_ecdsa_null_sha" = false;
          "security.ssl3.ecdh_rsa_null_sha" = false;
          "security.ssl3.ecdh_ecdsa_null_sha" = false;
          "security.ssl3.rsa_seed_sha" = false;
          "security.ssl3.rsa_rc4_40_md5" = false;
          "security.ssl3.rsa_rc2_40_md5" = false;
          "security.ssl3.rsa_1024_rc4_56_sha" = false;
          "security.ssl3.rsa_camellia_128_sha" = false;
          "security.ssl3.ecdhe_rsa_aes_128_sha" = false;
          "security.ssl3.ecdhe_ecdsa_aes_128_sha" = false;
          "security.ssl3.ecdh_rsa_aes_128_sha" = false;
          "security.ssl3.ecdh_ecdsa_aes_128_sha" = false;
          "security.ssl3.dhe_rsa_camellia_128_sha" = false;
          "security.ssl3.dhe_rsa_aes_128_sha" = false;
          "security.ssl3.ecdh_ecdsa_rc4_128_sha" = false;
          "security.ssl3.ecdh_rsa_rc4_128_sha" = false;
          "security.ssl3.ecdhe_ecdsa_rc4_128_sha" = false;
          "security.ssl3.ecdhe_rsa_rc4_128_sha" = false;
          "security.ssl3.rsa_rc4_128_md5" = false;
          "security.ssl3.rsa_rc4_128_sha" = false;
          "security.tls.unrestricted_rc4_fallback" = false;
          "security.ssl3.dhe_dss_des_ede3_sha" = false;
          "security.ssl3.dhe_rsa_des_ede3_sha" = false;
          "security.ssl3.ecdh_ecdsa_des_ede3_sha" = false;
          "security.ssl3.ecdh_rsa_des_ede3_sha" = false;
          "security.ssl3.ecdhe_ecdsa_des_ede3_sha" = false;
          "security.ssl3.ecdhe_rsa_des_ede3_sha" = false;
          "security.ssl3.rsa_des_ede3_sha" = false;
          "security.ssl3.rsa_fips_des_ede3_sha" = false;
          "security.ssl3.ecdh_rsa_aes_256_sha" = false;
          "security.ssl3.ecdh_ecdsa_aes_256_sha" = false;
          "security.ssl3.rsa_camellia_256_sha" = false;
          "security.ssl3.ecdhe_ecdsa_aes_128_gcm_sha256" = true;
          "security.ssl3.ecdhe_rsa_aes_128_gcm_sha256" = true;
          "security.ssl3.dhe_rsa_camellia_256_sha" = false;
          "security.ssl3.dhe_rsa_aes_256_sha" = false;
          "security.ssl3.dhe_dss_aes_128_sha" = false;
          "security.ssl3.dhe_dss_aes_256_sha" = false;
          "security.ssl3.dhe_dss_camellia_128_sha" = false;
          "security.ssl3.dhe_dss_camellia_256_sha" = false;
          "security.ssl3.rsa_aes_256_sha" = false;
          "security.ssl3.rsa_aes_128_sha" = false;
          "security.ssl3.ecdhe_rsa_aes_256_sha" = false;
          "security.ssl3.ecdhe_ecdsa_aes_256_sha" = false;
        };
        id = 0;
      };
    };
  };
}
