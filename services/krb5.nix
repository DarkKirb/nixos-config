{ ... }:
{
  security.krb5 = {
    enable = true;
    settings = {
      libdefaults = {
        default_realm = "AD.CHIR.RS";
        dns_lookup_realm = false;
        dns_lookup_kdc = true;
      };
      realms."AD.CHIR.RS".default_domain = "ad.chir.rs";
      domain_realm.nas = "AD.CHIR.RS";
    };
  };
}
