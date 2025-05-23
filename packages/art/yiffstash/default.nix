{
  fetchgit,
  python,
  writeScript,
}:
let
  source = builtins.fromJSON (builtins.readFile ./source.json);
  python' = python.withPackages (pkgs: with pkgs; [ requests ]);
  src = fetchgit {
    inherit (source)
      url
      rev
      sha256
      fetchLFS
      ;
  };
in
writeScript "yiffstash" "cd ${src}; ${python'}/bin/python ${src}/tumblrbot.py"
