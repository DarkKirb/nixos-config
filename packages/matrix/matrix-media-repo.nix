{ buildGoModule
, fetchFromGitHub
, git
}: buildGoModule rec {
  pname = "matrix-media-repo";
  version = "1.2.12";
  src = fetchFromGitHub {
    owner = "turt2live";
    repo = pname;
    rev = "v${version}";
    sha256 = "1j6y7alr60mmj5h014qmpz9a5qjv8cm61andwdacb0dqjjbvsm0z";
  };
  vendorSha256 = "sha256-wRxzA5JQ/Sx06YZHEhFH0UGmPKM2GVjo022kM4Ponlo=";
  nativeBuildInputs = [
    git
  ];
  patches = [
    ./matrix-media-repo.patch
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
