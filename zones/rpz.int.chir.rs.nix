{
  pkgs,
  hosts-list,
  ...
}: let
  hostfiles-lists = [
    {
      name = "Unified-fakenews-gambling";
      path = "${hosts-list}/alternates/fakenews-gambling/hosts";
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
    echo "@ 3600 IN SOA ns1.chir.rs. lotte.chir.rs. ${toString hosts-list.lastModified} 86400 7200 2592000 86400" > $out
    echo "@ 3600 IN NS ns1.chir.rs. " >> $out
    echo "@ 3600 IN NS ns2.chir.rs. " >> $out
    echo "@ 3600 IN NS ns3.chir.rs. " >> $out
    echo "@ 3600 IN NS ns4.chir.rs. " >> $out
    echo "@ 3600 IN NS ns1.darkkirb.de. " >> $out
    echo "@ 3600 IN NS ns2.darkkirb.de. " >> $out
    echo "@ 3600 IN NS ns1.shitallover.me. " >> $out
    echo "@ 3600 IN NS ns2.shitallover.me. " >> $out
    sed 's/$/ IN CNAME ./' ${concat-hostname-list} >> $out
  ''
