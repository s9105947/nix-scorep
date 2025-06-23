{ stdenv
, lib
, fetchurl
}:
with import ./util.nix { lib = lib; };
stdenv.mkDerivation rec {
  pname = "cubelib";
  version = "4.9";
  src = fetchurl {
    url = "http://apps.fz-juelich.de/scalasca/releases/cube/${majorminor version}/dist/${pname}-${version}.tar.gz";
    sha256 = "sha256-oGWPW/P3S/fc9GWrbjBHZ1GtB+uTYYgBvc8ZC6MClEM=";
  };
  enableParallelBuilding = true;
  # overwrite false-negative check
  ax_cv_cxx_compile_cxx14 = "yes";
  configureFlags = [
    "--with-frontend-libz=no"
    "--with-compression=no"
  ];
}
