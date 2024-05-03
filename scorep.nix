{ stdenv
, fetchurl
, lib
, gcc
, opari2
, cubew
, cubelib
, otf2
, libbfd_2_38
, which
, with_mpi ? true
, mpi
}:
stdenv.mkDerivation rec {
  pname = "scorep";
  version = "8.4";
  src = fetchurl {
    url = "http://perftools.pages.jsc.fz-juelich.de/cicd/${pname}/tags/${pname}-${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-e73poHIdJ8xiBbrxPBYmgzvPursfM7MlotZ5dikPf4o=";
  };
  propagatedBuildInputs = [
    gcc opari2 cubew cubelib otf2
  ] ++ (lib.optionals with_mpi [ mpi ]);
  buildInputs = [ libbfd_2_38 ];

  nativeBuildInputs = [
    which # required to detect mpi
  ];

  enableParallelBuilding = true;
  configureFlags = [
    "--with-nocross-compiler-suite=gcc"
    "--enable-gcc-plugin"
    "--without-shmem"
    "--with-opari2=${opari2}"
    "--with-cubew=${cubew}"
    "--with-cubelib=${cubelib}"
    "--with-otf2=${otf2}"
  ] ++ (if with_mpi then [ "--with-mpi=openmpi" ] else [ "--without-mpi" ]);
}
