{ stdenvNoCC, fetchFromGitHub, ibus, ibus-engines }: stdenvNoCC.mkDerivation rec {
  pname = "ibus-toki-pona";
  version = "20220215";
  src = fetchFromGitHub {
    owner = "Id405";
    repo = "sitelen-pona-ucsur-guide";
    rev = "43da00449a99c0b8aaa6f5099d0dc1f795c7c39f";
    sha256 = "sha256-CIa0wJnv1G0jpS8l2cjEFey1pdQuJPftiwZ5MZyriJ8=";
  };
  buildInputs = [ ibus ibus-engines.table ];

  buildPhase = ''
    ibus-table-createdb -n tokipona.db tokipona.txt
  '';
  installPhase = ''
    install -m444 -Dt $out/share/ibus-table/tables tokipona.db
  '';
}
