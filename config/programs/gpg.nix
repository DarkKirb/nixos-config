{ pkgs, ... }: {
  programs.gpg = {
    enable = true;
    mutableKeys = false;
    mutableTrust = false;
    publicKeys = [
      {
        source = ../../keys/lotte_chir.rs.pgp;
        trust = 5;
      }
      {
        source = ../../keys/darkkirb_darkkirb.de.pgp;
        trust = 5;
      }
      {
        source = ../../keys/mdelenk_hs-mittweida.de.pgp;
        trust = 5;
      }
    ];
    scdaemonSettings = {
      disable-ccid = true;
      pcsc-driver = "${pkgs.pcsclite}/lib/libpcsclite.so.1";
      reader-port = "Yubico YubiKey";
    };
    settings = {
      # https://github.com/drduh/config/blob/master/gpg.conf
      personal-cipher-preferences = "AES256 AES192 AES";
      personal-digest-preferences = "SHA512 SHA384 SHA256";
      personal-compress-preferences = "ZLIB BZIP2 ZIP Uncompressed";
      default-preference-list = "SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed";
      cert-digest-algo = "SHA512";
      s2k-digest-algo = "SHA512";
      s2k-cipher-algo = "AES256";
      charset = "utf-8";
      fixed-list-mode = true;
      no-comments = true;
      no-emit-version = true;
      no-greeting = true;
      keyid-format = "0xlong";
      list-options = "show-uid-validity";
      verify-options = "show-uid-validity";
      with-fingerprint = true;
      with-key-origin = true;
      require-cross-certification = true;
      no-symkey-cache = true;
      use-agent = true;
      throw-keyids = true;
      keyserver = [ "hkps://keys.openpgp.org" "hkps://keyserver.ubuntu.com:443" "hkps://hkps.pool.sks-keyservers.net" "hkps://pgp.ocf.berkeley.edu" ];
      auto-key-locate = [ "local" "dane" "cert" "wkd" ];
    };
  };
  services.gpg-agent = {
    enable = true;
  };
}
