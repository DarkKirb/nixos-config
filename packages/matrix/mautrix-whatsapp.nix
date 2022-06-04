{ buildGo118Module
, fetchFromGitHub
, olm
}: buildGo118Module rec {
  pname = "mautrix-whatsapp";
  version = "0.4.0";
  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "whatsapp";
    rev = "v${version}";
    sha256 = "sha256-2F0smK2L9Xj3/65j7vwwGT1OLxcTqkImpn16wB5rWDw=";
  };
  proxyVendor = true;
  vendorSha256 = "sha256-CuLlg7lynJNNkGhZEh+Un6Mx3whhcU4hHF0rCggo6h4=";
  buildInputs = [ olm ];
}
