{ lib }:
{
  majorminor = version:
    lib.strings.concatStringsSep "."
      (lib.lists.sublist 0 2
        (lib.strings.splitString "." version));
}
