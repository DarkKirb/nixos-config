{
  bg ? null,
  boot ? null,
  de ? null,
  ...
}:
{
  imports =
    (
      if bg != null then
        [
          ./bg/${bg}.nix
        ]
      else
        [ ]
    )
    ++ (
      if boot != null then
        [
          ./boot/${boot}.nix
        ]
      else
        [ ]
    )
    ++ (
      if de != null then
        [
          ./de/${de}.nix
        ]
      else
        [ ]
    );
}
