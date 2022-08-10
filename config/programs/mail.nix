{pkgs, ...}: let
  mailcap = pkgs.writeText "mailcap" ''
    text/html; ${pkgs.w3m}/bin/w3m -I %{charset} -T text/html; copiousoutput;
    image/*; ${pkgs.imv}/bin/imv %s
  '';
  molokai = pkgs.writeText "molokai.muttrc" ''
    # color setup
    #
    # ======================================================================
    # INDEX OBJECT     PATTERN?      pattern description
    # index            pattern               default highlighting of the entire index line
    # index_date                             the date field
    # index_flags      pattern       %S %Z   the message flags
    # index_number                   %C      the message number
    # index_collapsed                %M      the number of messages in a collapsed thread
    # index_author     pattern       %AaFLn  the author name
    # index_subject    pattern       %s      the subject line
    # index_size                     %c %l   the message size
    # index_label                    %y %Y   the message label
    # index_tags                     %g      the transformed message tags
    # index_tag        pattern/tag   %G      an individual message tag
    # ======================================================================

    color  normal        default    default
    color  index_number      brightblack  default
    color  index_date      magenta    default
    color  index_flags      yellow    default    .
    color  index_collapsed      cyan    default
    color  index        green    default    ~N
    color  index        green    default    ~v~(~N)
    color  index        red    default    ~F
    color  index        cyan    default    ~T
    color  index        blue    default    ~D
    color  index_label      brightred  default
    color  index_tags      red    default
    color  index_tag      brightmagenta  default    "encrypted"
    color  index_tag      brightgreen  default    "signed"
    color  index_tag      yellow    default    "attachment"
    color  body        brightwhite  default    ([a-zA-Z\+]+)://[\-\.,/%~_:?&=\#a-zA-Z0-9]+  # urls
    color  body        green    default    [\-\.+_a-zA-Z0-9]+@[\-\.a-zA-Z0-9]+    # mail addresses
    color  attachment      yellow    default
    color  signature      green    default
    color  search        brightred  black

    color  indicator      cyan    brightblack
    color  error        brightred  default
    color  status        brightcyan  brightblack
    color  tree        brightcyan  default
    color  tilde        cyan    default
    color  progress      white    red

    color  sidebar_indicator    brightred  default
    color  sidebar_highlight    cyan    brightblack
    color  sidebar_divider      red    default
    color  sidebar_flagged      red    default
    color  sidebar_new      green    default

    color  hdrdefault      color81    default
    color  header        green    default    "^Subject: .*"
    color  header        yellow    default    "^Date: .*"
    color  header        red    default    "^Tags: .*"

    color  quoted        color60    default
    color  quoted1        yellow    default

    color  body        brightgreen  default    "Good signature from.*"
    color  body        green    default    "Fingerprint:( [A-Z0-9]{4}){5} ( [A-Z0-9]{4}){5}"
    color  body        brightred  default    "Bad signature from.*"
    color  body        brightred  default    "Note: This key has expired!"
    color  body        brightmagenta  default    "Problem signature from.*"
    color  body        brightmagenta  default    "WARNING: .*"

    color  compose header      color81    default
    color  compose security_both    brightgreen  default
    color  compose security_sign    brightmagenta  default
    color  compose security_encrypt  brightyellow  default
    color  compose security_none    brightred  default
  '';
in {
  services.imapnotify.enable = true;
  programs.mbsync.enable = true;
  programs.notmuch = {
    enable = true;
    hooks = builtins.readFile ./hooks.py;
    bindings = {
      envelope = {
        k = "call hooks.attach_my_key(ui)";
        K = "call hooks.attach_keys(ui)";
        "control k" = "call hooks.attach_recipient_keys(ui)";
      };
      search = {
        "'T t'" = "tag todo; untag inbox";
        "'T g'" = "tag doing; untag todo,blocked,inbox";
        "'T b'" = "tag blocked; untag todo,doing,inbox";
        "'T d'" = "tag done; untag todo,doing,blocked,inbox";
      };
      thread = {
        k = "call hooks.import_keys(ui)";
        "'T t'" = "tag todo; untag inbox";
        "'T g'" = "tag doing; untag todo,blocked,inbox";
        "'T b'" = "tag blocked; untag todo,doing,inbox";
        "'T d'" = "tag done; untag todo,doing,blocked,inbox";
      };
    };
    settings = {
      envelope_txt2html = "${pkgs.pandoc}/bin/pandoc -f markdown -t html -s --self-contained --template=${../../extra/GitHub.html5}";
      envelope_html2txt = "${pkgs.pandoc}/bin/pandoc -t markdown -f html";
      theme = "alot-theme";
      themes_dir = toString ../../extra;
    };
  };
  programs.neomutt = {
    enable = true;
    vimKeys = true;
    sidebar = {
      enable = true;
    };
    binds = [
      {
        key = "\\CA";
        action = "sidebar-next";
        map = ["index" "pager"];
      }
      {
        key = "\\CL";
        action = "sidebar-prev";
        map = ["index" "pager"];
      }
      {
        key = "\\CP";
        action = "sidebar-open";
        map = ["index" "pager"];
      }
      {
        key = "<Return>"; # what the fuck is this mapping
        action = "display-message";
        map = ["index"];
      }
      {
        key = "\\CV";
        action = "display-message"; # i give up
        map = ["index"];
      }
    ];
    extraConfig = ''
      virtual-mailboxes "To Do" "notmuch://?query=tag:todo"
      virtual-mailboxes "To Read" "notmuch://?query=tag:toread"
      virtual-mailboxes "Blocked" "notmuch://?query=tag:blocked"
      virtual-mailboxes "Archive" "notmuch://?query=tag:archive"
      macro index,pager A "<modify-labels-then-hide>+archive -unread -inbox\n"
      bind index,pager y modify-labels
      set mailcap_path = ${mailcap}
      source ${molokai}
    '';
  };
  programs.msmtp.enable = true;
  home.file.".mailcap".text = ''
    image/*; ${pkgs.imv}/bin/imv '%s'
    text/html;  ${pkgs.w3m}/bin/w3m -dump -o document_charset=%{charset} '%s'; nametemplate=%s.html; copiousoutput
  '';
  programs.afew = {
    enable = true;
    extraConfig = ''
      [ArchiveSentMailsFilter]
      [DMARCReportInspectionFilter]
      [HeaderMatchingFilter.1]
      header = X-Spam
      pattern = Yes
      tags = +spam
      [KillThreadsFilter]
      [ListMailsFilter]
      [Filter.0]
      query = from:*@hs-mittweida.de
      tags = +university
      [Filter.1]
      query = tag:new
      tags = +inbox;+unread;-new
    '';
  };
}
