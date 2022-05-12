{ ... }: {
  services.syncthing = {
    enable = true;
    devices = {
      HuskyPhone = {
        id = "K4WRMGA-3PNENMC-FT4FGR2-DBOJUAW-QG6GS7E-WDJWA5Q-7KEQI3K-T4D3AA3";
      };
      nutty-noon = {
        addresses = [
          "quic://nutty-noon.int.chir.rs:51820"
          "tcp://nutty-noon.int.chir.rs:51820"
        ];
        id = "LW664LC-AZIJD5E-EJQE6OJ-K4IIR2K-OBAA762-DAJA65I-IQPEOGE-CD3YXA5";
      };
      Maruno = {
        id = "R7NYMWC-QR56IC2-TGQWVJG-HL5VTQX-UTPD3YN-76MTTSW-UEW4VZJ-N7SMVAP";
      };
      thinkrac = {
        addresses = [
          "quic://thinkrac.int.chir.rs:51820"
          "tcp://thinkrac.int.chir.rs:51820"
        ];
        id = "SION6SB-UTOUYKL-UHJBK4D-S6WNUZO-BOB5YI3-7JGUG6S-PTKKGX3-VAWPDAP";
      };
      phone = {
        addresses = [
          "quic://[fd0d:a262:1fa6:e621:480:b859:2a43:7101]:51820"
          "tcp://[fd0d:a262:1fa6:e621:480:b859:2a43:7101]:51820"
        ];
        id = "WDVUWGL-IZKDU3V-MFG5ZRO-BKKMFYR-CYKFLGH-P4UPQ2O-F5KWF2M-EBLHBA3";
      };
      Huskydev = {
        id = "XKAXBTK-AT6Q2LU-DEOTKFM-LUCPZME-BGI4EKG-53DZ3L5-OCWG72B-Q7JSXQU";
      };
      WindowsPc = {
        id = "YPACS7B-33LLN2N-WULGQVG-VXHRDZJ-MNT5JDC-BT7XQNC-C7M3UB6-SD47JQG";
      };
    };
    folders = {
      ".wine" = {
        devices = [
          "nutty-noon"
          "thinkrac"
        ];
        id = "9dsac-mdcw7";
      };
      "lennyface" = {
        devices = [
          "Huskydev"
        ];
        id = "aa7tq-xljao";
      };
      "Music-flac" = {
        devices = [
          "HuskyPhone"
          "nutty-noon"
          "Maruno"
          "thinkrac"
          "phone"
          "Huskydev"
          "WindowsPc"
        ];
        id = "aahbh-r3esw";
      };
      "Studium" = {
        devices = [
          "nutty-noon"
          "thinkrac"
          "WindowsPc"
        ];
        id = "esljk-osrt6";
      };
      Pictures = {
        devices = [
          "nutty-noon"
          "thinkrac"
          "phone"
          "WindowsPc"
        ];
        id = "f3dqm-u2jtt";
      };
      Data = {
        devices = [
          "nutty-noon"
          "thinkrac"
          "phone"
          "WindowsPc"
        ];
        id = "m6n5r-kkiyj";
      };
      CarolineFlac = {
        devices = [
          "HuskyPhone"
          "nutty-noon"
          "Maruno"
          "thinkrac"
          "phone"
          "Huskydev"
          "WindowsPc"
        ];
        id = "qgvvc-uiohe";
      };
      Camera = {
        devices = [
          "nutty-noon"
          "thinkrac"
          "phone"
          "WindowsPc"
        ];
        id = "redmi_note_6_pro_y714-photos";
      };
      reveng = {
        devices = [
          "nutty-noon"
          "thinkrac"
        ];
        id = "txvu6-h3djq";
      };
      Music = {
        devices = [
          "nutty-noon"
          "thinkrac"
          "phone"
          "WindowsPc"
        ];
        id = "uotge-rsr0d";
      };
      Documents = {
        devices = [
          "nutty-noon"
          "thinkrac"
          "phone"
          "WindowsPc"
        ];
        id = "vw3qm-e2xec";
      };
    };
  };
  networking.firewall.interfaces."wg0".allowedTCPPorts = [ 8384 ];
}
