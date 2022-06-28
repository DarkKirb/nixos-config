{pkgs, ...}: let
in {
  services.imapnotify.enable = true;
  programs.mbsync.enable = true;
  programs.notmuch.enable = true;
  programs.alot = {
    enable = true;
    hooks = builtins.readFile ./hooks.py;
    bindings = {
      envelope = {
        k = "call hooks.attach_my_key(ui)";
        K = "call hooks.attach_keys(ui)";
        "control k" = "call hooks.attach_recipient_keys(ui)";
      };
      thread = {
        k = "call hooks.import_keys(ui)";
      };
    };
    settings = {
      envelope_txt2html = "${pkgs.pandoc}/bin/pandoc -f markdown -t html -s --self-contained --template=${../../extra/GitHub.html5}";
      envelope_html2txt = "${pkgs.pandoc}/bin/pandoc -t markdown -f html";
    };
  };
  programs.msmtp.enable = true;
  home.file.".mailcap".text = ''
    image/*; ${pkgs.kitty}/bin/kitty +kitten icat '%s'; copiousoutput
    text/html;  ${pkgs.w3m}/bin/w3m -dump -o document_charset=%{charset} '%s'; nametemplate=%s.html; copiousoutput
  '';
}
