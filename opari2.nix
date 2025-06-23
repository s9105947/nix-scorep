{ stdenv
, fetchurl
, which
, gawk
}:
stdenv.mkDerivation rec {
  pname = "opari2";
  version = "2.0.9";
  src = fetchurl {
    url = "https://perftools.pages.jsc.fz-juelich.de/cicd/${pname}/tags/${pname}-${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-1XE591fFZmr6rq1F7T0JVKm5jEps72sir+ZycHz/13k=";
  };
  nativeBuildInputs = [ which ];
  propagatedBuildInputs = [ gawk ];
  doCheck = true;
  enableParallelBuilding = true;
}
