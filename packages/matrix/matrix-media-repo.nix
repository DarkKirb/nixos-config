{ buildGo116Module
, fetchFromGitHub
, git
}: buildGo116Module rec {
  pname = "matrix-media-repo";
  version = "1.2.12";
  src = fetchFromGitHub {
    owner = "hifi";
    repo = pname;
    rev = "8e27b16955bf9f1437709c557144a25bfbb0aecb";
    sha256 = "19iakdd9hd8gx1n5m3yd3kv3zbv4gdbw8h1nn6xm8w3qnkrfrn80";
  };
  proxyVendor = true;
  vendorSha256 = "sha256-QBV7NbhMLFABO0/t0ZGaa0EktFgG517t3uvbblLnv9s=";
  nativeBuildInputs = [
    git
  ];
  buildPhase = ''
    GOBIN=$PWD/bin go install -v ./cmd/compile_assets
    $PWD/bin/compile_assets
    GOBIN=$PWD/bin go install -ldflags "-X github.com/turt2live/matrix-media-repo/common/version.GitCommit=$(git rev-list -1 HEAD) -X github.com/turt2live/matrix-media-repo/common/version.Version=$(git describe --tags)" -v ./cmd/...
  '';
  installPhase = ''
    mkdir $out
    cp -rv bin $out
  '';
}
