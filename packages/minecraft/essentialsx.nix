{
  coreutils,
  fetchFromGitHub,
  fetchurl,
  findutils,
  git,
  gnused,
  gradle,
  openjdk17_headless,
  perl,
  stdenv,
}: let
  pname = "EssentialsX";
  version = "2.19.2";

  src = fetchFromGitHub {
    owner = "EssentialsX";
    repo = "Essentials";
    rev = version;
    sha256 = "00my0yg3i0kd4ysixhsxwm5y8377svkx9jbp2mlcf89hpbdqh50q";
    leaveDotGit = true;
  };

  addResolveStep = ''
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

      # this above script is broken, fix the result
      mv $out/maven/org/gradle/kotlin/kotlin-dsl/org.gradle.kotlin.kotlin-dsl.gradle.plugin/2.1.7 $out/maven/org/gradle/kotlin/kotlin-dsl/
    '';
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256-lNtkOErTlzheYXXBXN3yMjnouq5QQOoN/rgqUdFgB9k=";
  };
in rec {
  # TODO: current broken
  essentialsx-full = stdenv.mkDerivation {
    inherit pname version src;

    nativeBuildInputs = [git];

    buildPhase = ''
      ${gnused}/bin/sed -i 's#mavenCentral#maven { url = uri("${deps}/maven") }; mavenCentral#' settings.gradle.kts
      ${gnused}/bin/sed -i '/repositoriesMode/d' settings.gradle.kts
      ${gnused}/bin/sed -i 's#gradlePluginPortal#maven { url = uri("${deps}/maven") }; gradlePluginPortal#' build-logic/build.gradle.kts
      cat settings.gradle.kts
      export GRADLE_USER_HOME=$(${coreutils}/bin/mktemp -d)
      ${gradle}/bin/gradle --offline --no-daemon --info -Dorg.gradle.java.home=${openjdk17_headless} build
    '';

    installPhase = ''
      mkdir -p $out
      find . -name '*.jar'
      exit 1
    '';
  };
  essentialsx = fetchurl {
    url = "https://github.com/EssentialsX/Essentials/releases/download/2.20.0/EssentialsX-2.20.0.jar";
    sha256 = "2c55dafb9350bebec21b530aba18a51f770d95356b218427ba9b5840e4aabbc8";
  };
  essentialsx-chat = fetchurl {
    url = "https://github.com/EssentialsX/Essentials/releases/download/2.20.0/EssentialsXChat-2.20.0.jar";
    sha256 = "095a6c95183ecf900efd7007554a2caea00eb7851cf8965893dab1483f00fd81";
  };
  essentialsx-spawn = fetchurl {
    url = "https://github.com/EssentialsX/Essentials/releases/download/2.20.0/EssentialsXSpawn-2.20.0.jar";
    sha256 = "df3203cf052cdaf15554d5cbebec889b049b1e5b4d33bf497ea8b4a91e37e10c";
  };
}
