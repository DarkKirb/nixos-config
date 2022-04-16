{ writeTextFile, python3, python3Packages }:
let environment = python3.buildEnv.override {
  extraLibs = with python3Packages; [
    boto3
  ];
}; in
writeTextFile {
  name = "clean-s3-cache.py";
  executable = true;
  destination = "/bin/clean-s3-cache.py";
  text = builtins.replaceStrings [ "#SHEBANG#" ] [ "${environment}/bin/python" ] (builtins.readFile ./clean-s3-cache.py);
}
