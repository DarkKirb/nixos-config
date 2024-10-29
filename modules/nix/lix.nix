{
  lix-module,
  inTester,
  ...
}: {
  imports =
    if inTester
    then []
    else [lix-module.nixosModules.default];
}
