{ stdenv
, fetchurl
, python3
}:
stdenv.mkDerivation rec {
  pname = "otf2";
  version = "3.0.3";
  src = fetchurl {
    url = "https://perftools.pages.jsc.fz-juelich.de/cicd/${pname}/tags/${pname}-${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-GKOQX3kXNAOH4+3I5XZvMasa9B9OzFZl2mx2nKIcTug=";
  };
  enableParallelBuilding = true;
  buildInputs = [
    (python3.withPackages (ps: [ps.six]))
  ];
}
