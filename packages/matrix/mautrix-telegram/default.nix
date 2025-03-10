{
  lib,
  python3,
  fetchFromGitHub,
  mautrix-python,
  tulir-telethon,
}:
let
  source = builtins.fromJSON (builtins.readFile ./source.json);
in
python3.pkgs.buildPythonPackage {
  pname = "mautrix-telegram";
  version = source.date;
  disabled = python3.pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "telegram";
    inherit (source) rev sha256;
  };

  patches = [
    ./0001-Re-add-entrypoint.patch
    ./mautrix-telegram-sticker.patch
  ];

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "asyncpg>=0.20,<0.27" "asyncpg>=0.20"
  '';

  propagatedBuildInputs = with python3.pkgs; [
    ruamel-yaml
    python-magic
    CommonMark
    aiohttp
    yarl
    mautrix-python
    tulir-telethon
    asyncpg
    Mako
    # optional
    cryptg
    aiodns
    brotli
    pillow
    qrcode
    phonenumbers
    prometheus-client
    aiosqlite
    python-olm
    pycryptodome
    unpaddedbase64
    setuptools
  ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/mautrix/telegram";
    description = "A Matrix-Telegram hybrid puppeting/relaybot bridge";
    platforms = platforms.linux;
    broken = !(python3.pkgs ? cryptg);
  };
}
