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
  ];

  src = fetchFromGitHub {
    owner = "openstenoproject";
    repo = "plover_plugins_manager";
    inherit (source) rev sha256;
  };
}
