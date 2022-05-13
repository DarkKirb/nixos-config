{ pkgs, lib, ... }: {
  home.packages = [ pkgs.keepassxc ];
  systemd.user.services.keepassxc = {
    Unit = {
      Description = "keepassxc";
      After = [ "graphical-session-pre.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.keepassxc}/bin/keepassxc";
    };
  };
  xdg.configFile."keepassxc/keepassxc.ini".text = ''
    [General]
    ConfigVersion=1

    [Browser]
    CustomProxyLocation=
    Enabled=true

    [FdoSecrets]
    Enabled=true

    [GUI]
    AdvancedSettings=true
    ApplicationTheme=dark
    TrayIconAppearance=monochrome-light

    [KeeShare]
    Active="<?xml version=\"1.0\"?>\n<KeeShare xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">\n  <Active/>\n</KeeShare>\n"
    Foreign="<?xml version=\"1.0\"?>\n<KeeShare xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">\n  <Foreign/>\n</KeeShare>\n"
    Own="<?xml version=\"1.0\"?>\n<KeeShare xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">\n  <PrivateKey/>\n  <PublicKey/>\n</KeeShare>\n"
    QuietSuccess=true

    [PasswordGenerator]
    AdditionalChars=
    AdvancedMode=true
    Braces=true
    Dashes=true
    EASCII=false
    EnsureEvery=false
    ExcludedChars=
    Length=10
    Logograms=true
    Math=true
    Punctuation=true
    Quotes=true
    SpecialChars=true

    [Security]
    IconDownloadFallback=true
  '';
}
