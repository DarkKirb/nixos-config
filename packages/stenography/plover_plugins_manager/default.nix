{
  fetchFromGitHub,
  buildPythonPackage,
  plover,
  pip,
  pkginfo,
  pygments,
  readme_renderer,
  requests,
  requests-cache,
  requests-futures,
  setuptools,
  wheel,
  cmarkgfm,
}:
let
  source = builtins.fromJSON (builtins.readFile ./source.json);
in
buildPythonPackage {
  pname = "plover_plugins_manager";
  version = source.date;

  propagatedBuildInputs = [
    pip
    pkginfo
    plover
    pygments
    readme_renderer
    requests
    requests-cache
    requests-futures
    setuptools
    wheel
    cmarkgfm
  ];

  src = fetchFromGitHub {
    owner = "openstenoproject";
    repo = "plover_plugins_manager";
    inherit (source) rev sha256;
  };
}
