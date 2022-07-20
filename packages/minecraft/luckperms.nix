{
  coreutils,
  fetchFromGitHub,
  findutils,
  git,
  gnused,
  gradle,
  openjdk17_headless,
  perl,
  stdenv,
  lib,
  fetchurl,
  ...
}: let
  pname = "LuckPerms";
  version = "2022-04-08";

  src = fetchFromGitHub {
    owner = "LuckPerms";
    repo = "LuckPerms";
    rev = "207e4aa9f8c640ad3b17f844d79512f7b8fb2044";
    sha256 = "00xkhma322b19h93ccand8ldj2pn3jf43jcmpcpaakaaqrk2ph0x";
    leaveDotGit = true;
  };

  # Adds a gradle step that downloads all the dependencies to the gradle cache.
  addResolveStep = ''
    git tag v5.4 # thanks build script
    ${gnused}/bin/sed -i "s#'fabric',##" settings.gradle
    cat >>build.gradle <<HERE
    task resolveDependencies {
      doLast {
        project.rootProject.allprojects.each { subProject ->
          subProject.buildscript.configurations.each { configuration ->
            resolveConfiguration(subProject, configuration, "buildscript config \''${configuration.name}")
          }
          subProject.configurations.each { configuration ->
            resolveConfiguration(subProject, configuration, "config \''${configuration.name}")
          }
        }
      }
    }
    void resolveConfiguration(subProject, configuration, name) {
      if (configuration.canBeResolved) {
        logger.info("Resolving project {} {}", subProject.name, name)
        configuration.resolve()
      }
    }
    HERE
  '';

  deps = stdenv.mkDerivation {
    pname = "${pname}-deps";
    inherit version src;

    nativeBuildInputs = [git];
    postPatch = addResolveStep;
    buildPhase = ''
      export GRADLE_USER_HOME=$(${coreutils}/bin/mktemp -d)

      # Fetch the maven dependencies.
      ${gradle}/bin/gradle --no-daemon --info -Dorg.gradle.java.home=${openjdk17_headless} resolveDependencies
    '';
    installPhase = ''
      ${findutils}/bin/find $GRADLE_USER_HOME/caches/modules-2 -type f -regex '.*\.\(jar\|pom\)' \
        | ${perl}/bin/perl -pe 's#(.*/([^/]+)/([^/]+)/([^/]+)/[0-9a-f]{30,40}/([^/\s]+))$# ($x = $2) =~ tr|\.|/|; "${coreutils}/bin/install -Dm444 $1 \$out/maven/$x/$3/$4/$5" #e' \
        | sh
    '';
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256-V7FlGxa+Q3ljohPldxlhi2Ak93TiEUggwFELLaR787w=";
  };
in
  /*
   stdenv.mkDerivation {
  inherit pname version src;

  name = "${pname}-${version}.jar";

  nativeBuildInputs = [ git ];

  postPatch = addResolveStep;

  buildPhase = ''
  ${gnused}/bin/sed -i "s#'bukkit-legacy',##" settings.gradle
  ${gnused}/bin/sed -i "s#'bukkit-legacy:loader',##" settings.gradle
  ${gnused}/bin/sed -i "s#'bungee',##" settings.gradle
  ${gnused}/bin/sed -i "s#'bungee:loader',##" settings.gradle
  ${gnused}/bin/sed -i "s#'nukkit',##" settings.gradle
  ${gnused}/bin/sed -i "s#'nukkit:loader',##" settings.gradle
  ${gnused}/bin/sed -i "s#'sponge',##" settings.gradle
  ${gnused}/bin/sed -i "s#'sponge:loader',##" settings.gradle
  ${gnused}/bin/sed -i "s#'sponge:sponge-service',##" settings.gradle
  ${gnused}/bin/sed -i "s#'sponge:sponge-service-api8',##" settings.gradle
  ${gnused}/bin/sed -i "s#'velocity'##" settings.gradle
  export GRADLE_USER_HOME=$(${coreutils}/bin/mktemp -d)

  # add local maven repo
  ${gnused}/bin/sed -i "s#mavenCentral()#mavenCentral(); maven { url '${deps}/maven' }#" build.gradle
  ${gnused}/bin/sed -i "s#jcenter()#jcenter(); maven { url '${deps}/maven' }#" settings.gradle
  ${gnused}/bin/sed -i "s#'fabric',##" settings.gradle

  ${gradle}/bin/gradle --offline --no-daemon --info -Dorg.gradle.java.home=${openjdk17_headless} build
  '';

  installPhase = ''
  cp bukkit/loader/build/libs/LuckPerms-Bukkit-5.4.0.jar $out
  '';

  }
  */
  fetchurl {
    url = "https://ci.lucko.me/job/LuckPerms/1429/artifact/bukkit/loader/build/libs/LuckPerms-Bukkit-5.4.21.jar";
    sha256 = "bd9090b3cf1412d77ff58ee0c2c7229184306cc83ff18ff4681ea1b7116b3747";
  }
