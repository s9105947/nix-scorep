{ stdenv
, lib
, fetchurl
}:
with import ./util.nix { lib = lib; };
stdenv.mkDerivation rec {
  pname = "cubew";
  version = "4.9";
  src = fetchurl {
    url = "http://apps.fz-juelich.de/scalasca/releases/cube/${majorminor version}/dist/${pname}-${version}.tar.gz";
    sha256 = "sha256-TvdOgcVpv1MRdFnLpaHqUrXaxzlJP6g745Z4hAzSrN0=";
  };
  enableParallelBuilding = true;
  configureFlags = [
    "--with-backend-libz=no"
    "--with-frontend-libz=no"
    "--with-compression=no"
  ];
}
