{pkgs, ...}: let
in {
  services.imapnotify.enable = true;
  programs.mbsync.enable = true;
  programs.notmuch = {
    enable = true;
    new.tags = ["new"];
  };
  programs.alot = {
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
