{ stdenv
, lib
, fetchurl
}:
with import ./util.nix { lib = lib; };
stdenv.mkDerivation rec {
  pname = "cubew";
  version = "4.8.2";
  src = fetchurl {
    url = "http://apps.fz-juelich.de/scalasca/releases/cube/${majorminor version}/dist/${pname}-${version}.tar.gz";
    sha256 = "sha256-TzvPBiLCQpuJcrXrPxTXnsibgWHjwcxYYs7aQX15ddI=";
  };
  enableParallelBuilding = true;
  configureFlags = [
    "--with-backend-libz=no"
    "--with-frontend-libz=no"
    "--with-compression=no"
  ];
}
