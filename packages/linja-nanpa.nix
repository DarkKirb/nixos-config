{
  stdenvNoCC,
  fetchFromGitHub,
  fontforge,
}:
stdenvNoCC.mkDerivation rec {
  pname = "nasin-nanpa";
  version = "2.5.18";
  src = fetchFromGitHub {
    owner = "ETBCOR";
    repo = pname;
    rev = "f464d17d992ce1d974983a54a25b57948d27e811";
    sha256 = "sha256-zyKibrjvO5R0wbS2ocFRksJtrXjnW1I0gqkCAr/UZfc=";
  };
  nativeBuildInputs = [fontforge];
  buildPhase = ''
    fontforge -lang=ff -c 'Open($1); Generate($2)' "ffversions/2.5/nasin-nanpa-${version}.sfd" "nasin-nanpa.otf"
  '';
  installPhase = ''
    install -m444 -Dt $out/share/fonts/opentype/nasin-nanpa nasin-nanpa.otf
  '';
}
