{ stdenv
, fetchurl
, which
, gawk
}:
stdenv.mkDerivation rec {
  pname = "opari2";
  version = "2.0.8";
  src = fetchurl {
    url = "https://perftools.pages.jsc.fz-juelich.de/cicd/${pname}/tags/${pname}-${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-GW5ZoqYl5seVphJMYeeEutFC+fON8LT6TUNbqbnBlyE=";
  };
  nativeBuildInputs = [ which ];
  propagatedBuildInputs = [ gawk ];
  doCheck = true;
  enableParallelBuilding = true;
}
