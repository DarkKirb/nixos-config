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
    url = "https://github.com/EssentialsX/Essentials/releases/download/2.20.1/EssentialsX-2.20.1.jar";
    sha256 = "802ea30bda460ca4597e818925816933c123b08d8126a814fac28d03a61bf542";
  };
  essentialsx-chat = fetchurl {
    url = "https://github.com/EssentialsX/Essentials/releases/download/2.20.1/EssentialsXChat-2.20.1.jar";
    sha256 = "40aa5c20241ceb3007ebcb5cfbf19bf2c467b0c090ae50e70653ee87ab775ca6";
  };
  essentialsx-spawn = fetchurl {
    url = "https://github.com/EssentialsX/Essentials/releases/download/2.20.1/EssentialsXSpawn-2.20.1.jar";
    sha256 = "650d7c6a33865a02c5ffa4eb710def28e73d972c9aef85b2b1f4e71b9bd261a0";
  };
}
