{pkgs, ...}: {
  networking.wireguard.interfaces.wg0 = {
    postSetup = ''
      ${pkgs.iptables}/bin/iptables -A FORWARD -i wg0 -j ACCEPT
      ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.0.0.0/8 -o ens3 -j MASQUERADE
      ${pkgs.iptables}/bin/ip6tables -A FORWARD -i wg0 -j ACCEPT
      ${pkgs.iptables}/bin/ip6tables -t nat -A POSTROUTING -s fc00::/7 -o ens3 -j MASQUERADE
    '';

    postShutdown = ''
      ${pkgs.iptables}/bin/iptables -D FORWARD -i wg0 -j ACCEPT
      ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.0.0.0/8 -o ens3 -j MASQUERADE
      ${pkgs.iptables}/bin/ip6tables -D FORWARD -i wg0 -j ACCEPT
      ${pkgs.iptables}/bin/ip6tables -t nat -D POSTROUTING -s fc00::/7 -o ens3 -j MASQUERADE
    '';

    peers = [
      {
        publicKey = "/pQ86rAyPpM2tqzvk7NcKfEm72ENTVCSTTiHf6OrzDw=";
        allowedIPs = [
          "fd0d:a262:1fa6:e621:539c:94d8:30e1:fb8b/128"
          "10.0.0.1/32"
        ];
      }
      {
        publicKey = "YDh67pqmhWMPNWf1BYXeH4/GTScCWqoWuyIao3ZUcz4=";
        allowedIPs = [
          "fd0d:a262:1fa6:e621:480:b859:2a43:7101/128"
          "10.0.0.2/32"
        ];
      }
      {
        publicKey = "JZi7Lw8G5W2pnoqJWW6YfJm4OAaxhaneY8i3V9EO8X4=";
        allowedIPs = [
          "10.0.0.3/32"
          "fd0d:a262:1fa6:e621:66b6:3f04:5583:db63/128"
        ];
      }
      # nutty-noon
      {
        publicKey = "YYQmSJwipRkZJUsPV5DxhfyRBMdj/O1XzN+cGYtUi1s=";
        allowedIPs = [
          "fd0d:a262:1fa6:e621:47e6:24d4:2acb:9437/128"
        ];
      }
      # thinkrac
      {
        publicKey = "iKW9nomLyLY2f90UY66POzY8CfDhQrqOLqchERlR3TY=";
        allowedIPs = [
          "fd0d:a262:1fa6:e621:f45a:db9f:eb7c:1a3f/128"
        ];
      }
      # nas
      {
        publicKey = "RuQImASPojufJMoJ+zZ4FceC+mMN5vhxNR+i+m7g9Bc=";
        allowedIPs = [
          "fd0d:a262:1fa6:e621:bc9b:6a33:86e4:873b/128"
        ];
      }
    ];
  };
  boot.kernel.sysctl = {
    "net.ipv4.conf.all.forwarding" = true;
    "net.ipv6.conf.all.forwarding" = true;
  };
}
