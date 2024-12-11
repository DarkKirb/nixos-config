{
  lib,
  config,
  pkgs,
  ...
}:
{
  home.activation.konsolerc = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    PATH="${config.home.path}/bin:$PATH:${pkgs.jq}"
    palette=$HOME/.config/stylix/palette.json
    scheme=$HOME/.local/share/konsole/Stylix.colorscheme

    if ! [ -f $palette ]; then
      echo "Palette doesn't exist"
    else
      json=$( cat $palette )

      hex_to_rgb() {
        hex=$1
        r=$((16#''${hex:0:2}))
        g=$((16#''${hex:2:2}))
        b=$((16#''${hex:4:2}))
        echo "$r,$g,$b"
      }

      for base in base00 base01 base02 base03 base04 base05 base06 base07 base08 base09 base0A base0B base0C base0D base0E base0F; do
        hex=$(echo "$json" | jq -r ".$base")
        rgb=$(hex_to_rgb "$hex")
        declare "''${base}_rgb=$rgb"
      done

      mustache_template="
      [Background]
      Color={{base00-rgb-r}},{{base00-rgb-g}},{{base00-rgb-b}}
      [BackgroundIntense]
      Color={{base03-rgb-r}},{{base03-rgb-g}},{{base03-rgb-b}}
      [Color0]
      Color={{base00-rgb-r}},{{base00-rgb-g}},{{base00-rgb-b}}
      [Color0Intense]
      Color={{base03-rgb-r}},{{base03-rgb-g}},{{base03-rgb-b}}
      [Color1]
      Color={{base08-rgb-r}},{{base08-rgb-g}},{{base08-rgb-b}}
      [Color1Intense]
      Color={{base08-rgb-r}},{{base08-rgb-g}},{{base08-rgb-b}}
      [Color2]
      Color={{base0B-rgb-r}},{{base0B-rgb-g}},{{base0B-rgb-b}}
      [Color2Intense]
      Color={{base0B-rgb-r}},{{base0B-rgb-g}},{{base0B-rgb-b}}
      [Color3]
      Color={{base0A-rgb-r}},{{base0A-rgb-g}},{{base0A-rgb-b}}
      [Color3Intense]
      Color={{base0A-rgb-r}},{{base0A-rgb-g}},{{base0A-rgb-b}}
      [Color4]
      Color={{base0D-rgb-r}},{{base0D-rgb-g}},{{base0D-rgb-b}}
      [Color4Intense]
      Color={{base0D-rgb-r}},{{base0D-rgb-g}},{{base0D-rgb-b}}
      [Color5]
      Color={{base0E-rgb-r}},{{base0E-rgb-g}},{{base0E-rgb-b}}
      [Color5Intense]
      Color={{base0E-rgb-r}},{{base0E-rgb-g}},{{base0E-rgb-b}}
      [Color6]
      Color={{base0C-rgb-r}},{{base0C-rgb-g}},{{base0C-rgb-b}}
      [Color6Intense]
      Color={{base0C-rgb-r}},{{base0C-rgb-g}},{{base0C-rgb-b}}
      [Color7]
      Color={{base05-rgb-r}},{{base05-rgb-g}},{{base05-rgb-b}}
      [Color7Intense]
      Color={{base07-rgb-r}},{{base07-rgb-g}},{{base07-rgb-b}}
      [Foreground]
      Color={{base05-rgb-r}},{{base05-rgb-g}},{{base05-rgb-b}}
      [ForegroundIntense]
      Color={{base07-rgb-r}},{{base07-rgb-g}},{{base07-rgb-b}}
      [General]
      Description=Stylix
      Opacity=${toString config.stylix.opacity.terminal}
      Wallpaper=
      "
      populated_template=$(echo "$mustache_template" \
        | sed "s/{{base00-rgb-r}},{{base00-rgb-g}},{{base00-rgb-b}}/$base00_rgb/g" \
        | sed "s/{{base03-rgb-r}},{{base03-rgb-g}},{{base03-rgb-b}}/$base03_rgb/g" \
        | sed "s/{{base08-rgb-r}},{{base08-rgb-g}},{{base08-rgb-b}}/$base08_rgb/g" \
        | sed "s/{{base0B-rgb-r}},{{base0B-rgb-g}},{{base0B-rgb-b}}/$base0B_rgb/g" \
        | sed "s/{{base0A-rgb-r}},{{base0A-rgb-g}},{{base0A-rgb-b}}/$base0A_rgb/g" \
        | sed "s/{{base0D-rgb-r}},{{base0D-rgb-g}},{{base0D-rgb-b}}/$base0D_rgb/g" \
        | sed "s/{{base0E-rgb-r}},{{base0E-rgb-g}},{{base0E-rgb-b}}/$base0E_rgb/g" \
        | sed "s/{{base0C-rgb-r}},{{base0C-rgb-g}},{{base0C-rgb-b}}/$base0C_rgb/g" \
        | sed "s/{{base05-rgb-r}},{{base05-rgb-g}},{{base05-rgb-b}}/$base05_rgb/g" \
        | sed "s/{{base07-rgb-r}},{{base07-rgb-g}},{{base07-rgb-b}}/$base07_rgb/g")
      echo "$populated_template" > $scheme
    fi

  '';
}
