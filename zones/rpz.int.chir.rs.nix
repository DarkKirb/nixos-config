{
  pkgs,
  hosts-list,
  ...
}: let
  hostfiles-lists = [
    {
      name = "Badd-Boyz-Hosts";
      path = "${hosts-list}/data/Badd-Boyz-Hosts/hosts";
    }
    {
      name = "KADhosts";
      path = "${hosts-list}/data/KADhosts/hosts";
    }
    {
      name = "MetaMask";
      path = "${hosts-list}/data/MetaMask/hosts";
    }
    {
      name = "StevenBlack";
      path = "${hosts-list}/data/StevenBlack/hosts";
    }
    {
      name = "URLHaus";
      path = "${hosts-list}/data/URLHaus/hosts";
    }
    {
      name = "UncheckyAds";
      path = "${hosts-list}/data/UncheckyAds/hosts";
    }
    {
      name = "adaway.org";
      path = "${hosts-list}/data/adaway.org/hosts";
    }
    {
      name = "add.2o7Net";
      path = "${hosts-list}/data/add.2o7Net/hosts";
    }
    {
      name = "add.Dead";
      path = "${hosts-list}/data/add.Dead/hosts";
    }
    {
      name = "add.Risk";
      path = "${hosts-list}/data/add.Risk/hosts";
    }
    {
      name = "add.Spam";
      path = "${hosts-list}/data/add.Spam/hosts";
    }
    {
      name = "hostsVN";
      path = "${hosts-list}/data/hostsVN/hosts";
    }
    {
      name = "mvps.org";
      path = "${hosts-list}/data/mvps.org/hosts";
    }
    {
      name = "shady-hosts";
      path = "${hosts-list}/data/shady-hosts/hosts";
    }
    {
      name = "someonewhocares.org";
      path = "${hosts-list}/data/someonewhocares.org/hosts";
    }
    {
      name = "tiuxo";
      path = "${hosts-list}/data/tiuxo/hosts";
    }
    {
      name = "yoyo.org";
      path = "${hosts-list}/data/yoyo.org/hosts";
    }
    {
      name = "fakenews";
      path = "${hosts-list}/extensions/fakenews/hosts";
    }
    {
      name = "gambling";
      path = "${hosts-list}/extensions/gambling/hosts";
    }
  ];
  hostfile-to-hostname-list = hostfile: {
    name = "${hostfile.name}-hostnames";
    path = pkgs.runCommand "${hostfile.name}-hostnames" {} ''
      cp ${hostfile.path} $out
      sed -i '/^127.0.0.1.*localhost$/d' $out
      sed -i '/^127.0.0.1.*local$/d' $out
      sed -i '/^127.0.0.1.*localhost.localdomain$/d' $out
      sed -i '/^255.255.255.255/d' $out
      sed -i '/^::1/d' $out
      sed -i '/^fe00::/d' $out
      sed -i '/^ff00::/d' $out
      sed -i '/^ff02::/d' $out
      sed -i 's/^0.0.0.0\s\+//' $out
      sed -i 's/^127.0.0.1\s\+//' $out
    '';
  };
  hostname-lists =
    [
      {
        name = "Adguard-cname";
        path = "${hosts-list}/data/Adguard-cname/hosts";
      }
      {
        name = "minecraft-hosts";
        path = "${hosts-list}/data/minecraft-hosts/hosts";
      }
      {
        name = "no-application-dns";
        path = pkgs.writeText "no-application-dns" "use-application-dns.net";
      }
    ]
    ++ map hostfile-to-hostname-list hostfiles-lists;
  prepare-hostname-list = hostname-list:
    pkgs.runCommand "${hostname-list.name}-prepared" {} ''
      sed 's/#.*//' ${hostname-list.path} > $out
    '';
  prepared-hostname-list = map prepare-hostname-list hostname-lists;
  concat-hostname-list = pkgs.runCommand "concat-hostname-list" {} ''
    cat ${builtins.toString prepared-hostname-list} | sort -u | grep -Ev '^\s*$' > $out
  '';
in
  pkgs.runCommand "rpz.int.chir.rs" {} ''
    echo "@ 3600 IN SOA ns2.darkkirb.de. lotte.chir.rs. 2 86400 7200 2592000 86400" > $out
    echo "@ 3600 IN NS ns2.darkkirb.de. " >> $out
    sed 's/$/ IN CNAME ./' ${concat-hostname-list} >> $out
  ''
