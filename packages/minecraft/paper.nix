{ lib, stdenv, fetchurl, bash, openjdk17_headless }:
let
  mcVersion = "1.18.1";
  buildNum = "204";
  jar = fetchurl {
    url = "https://papermc.io/api/v2/projects/paper/versions/${mcVersion}/builds/${buildNum}/downloads/paper-${mcVersion}-${buildNum}.jar";
    sha256 = "sha256-DcPA5QfmqEZOTPBSvMcuA3mpKHxAH0ggmPyiBlNEHfk=";
  };
in
stdenv.mkDerivation {
  pname = "papermc";
  version = "${mcVersion}r${buildNum}";

  preferLocalBuild = true;

  dontUnpack = true;
  dontConfigure = true;

  buildPhase = ''
    cat > minecraft-server << EOF
    #!${bash}/bin/sh
    exec ${openjdk17_headless}/bin/java \$@ -jar $out/share/papermc/papermc.jar nogui
  '';

  installPhase = ''
    install -Dm444 ${jar} $out/share/papermc/papermc.jar
    install -Dm555 -t $out/bin minecraft-server
  '';

  meta = {
    description = "High-performance Minecraft Server";
    homepage = "https://papermc.io/";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ aaronjanse neonfuz ];
  };
}
