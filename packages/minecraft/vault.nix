{
  fetchFromGitHub,
  findutils,
  maven,
  openjdk8_headless,
  stdenv,
}: let
  pname = "Vault";
  version = "1.7.3";

  src = fetchFromGitHub {
    owner = "MilkBowl";
    repo = "Vault";
    rev = version;
    sha256 = "05g24xzi7ksncz9rjmwqva2cm7mm88i6qy49a9ad6wa0cgsf660h";
  };

  deps = stdenv.mkDerivation {
    name = "${pname}-deps";
    inherit version src;

    buildPhase = ''
      export JAVA_HOME=${openjdk8_headless}
      ${maven}/bin/mvn package -Dmaven.repo.local=$out/.m2
    '';
    installPhase = ''
      ${findutils}/bin/find $out -type f \
        -name \*.lastUpdated -or \
        -name resolver-status.properties -or \
        -name _remote.repositories \
        -delete
    '';
    dontFixup = true;
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256-vH/bnae6EmbGbgYDzMs1wKyLpFJqE+vNbukYmzrLmW8=";
  };
in
  stdenv.mkDerivation {
    inherit pname version src;

    name = "${pname}-${version}.jar";

    buildPhase = ''
      export JAVA_HOME=${openjdk8_headless}
      cp -dpR ${deps}/.m2 ./
      chmod +w -R .m2
      ${maven}/bin/mvn package --offline -Dmaven.repo.local=$(pwd)/.m2
    '';
    installPhase = ''
      cp target/${pname}-${version}.jar $out
    '';
  }
