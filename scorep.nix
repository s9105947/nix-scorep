{ stdenv
, fetchurl
, gcc
, opari2
, cubew
, cubelib
, otf2
, libbfd_2_38
}:
stdenv.mkDerivation rec {
  pname = "scorep";
  version = "8.3";
  src = fetchurl {
    url = "http://perftools.pages.jsc.fz-juelich.de/cicd/${pname}/tags/${pname}-${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-dskU5jGSIcBZI0WXo7xT2niO1nkXmsmcFHKE3O+xV0o=";
  };
  propagatedBuildInputs = [
    gcc opari2 cubew cubelib otf2
  ];
  buildInputs = [ libbfd_2_38 ];

  enableParallelBuilding = true;
  configureFlags = [
    "--with-nocross-compiler-suite=gcc"
    "--enable-gcc-plugin"
    "--without-mpi"
    "--without-shmem"
    "--with-opari2=${opari2}"
    "--with-cubew=${cubew}"
    "--with-cubelib=${cubelib}"
    "--with-otf2=${otf2}"
  ];
}
