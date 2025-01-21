{ ... }:
{
  security.tpm2 = {
    enable = true;
    abrmd.enable = true;
    pkcs11.enable = true;
    tctiEnvironment.enable = true;
  };
  systemd.tpm2.enable = true;
}
