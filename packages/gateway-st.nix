{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "gateway-st";
  version = "1.6.1";
  src = fetchFromGitHub {
    owner = "storj";
    repo = pname;
    rev = "v${version}";
    sha256 = "0v5gh03xaqld4l017fgzp46zi0r31az6cvk7war1brl2ir33nw47";
  };
  subPackages = ["."];
  vendorSha256 = "sha256-4cqNhQK/I3oRXYuF08bTU31SFkS8Mj6MPA7W6MIaxh8=";
  doCheck = false;
}
