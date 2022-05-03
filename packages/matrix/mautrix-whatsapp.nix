{ buildGo117Module
, fetchFromGitHub
, olm
}: buildGo117Module rec {
  pname = "mautrix-whatsapp";
  version = "0.3.1";
  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "whatsapp";
    rev = "v${version}";
    sha256 = "sha256-adsGPVG/EwpzOqhFJvn3anjTXwGY27a7Bc4NNkBeqJk=";
  };
  proxyVendor = true;
  vendorSha256 = "sha256-LmNzhyBSm3eHODbXjZc9sFsRczYZtc4ORk3X6/dcHfY=";
  buildInputs = [ olm ];
}
