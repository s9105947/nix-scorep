{ stdenv
, fetchurl
, python3
}:
stdenv.mkDerivation rec {
  pname = "otf2";
  version = "3.1.1";
  src = fetchurl {
    url = "https://perftools.pages.jsc.fz-juelich.de/cicd/${pname}/tags/${pname}-${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-Wk4BOlGsTteU/jXFW3AM1yA0b9p/M+yEx2uGpfuICm4=";
  };
  enableParallelBuilding = true;
  buildInputs = [
    (python3.withPackages (ps: [ps.six]))
  ];
}
