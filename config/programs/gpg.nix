{ ... }: {
  programs.gpg = {
    enable = true;
    mutableKeys = false;
    mutableTrust = false;
    publicKeys = [
      {
        source = ../../keys/darkkirb_darkkirb.de.pgp;
        trust = 5;
      }
      {
        source = ../../keys/mdelenk_hs-mittweida.de.pgp;
        trust = 5;
      }
    ];
  };
  services.gpg-agent = {
    enable = true;
  };
}