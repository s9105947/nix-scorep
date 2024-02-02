{ stdenv
, fetchgit
, cmake
, scorep
, protobuf
, openssl
}: stdenv.mkDerivation rec {
  pname = "scorep_plugin_metricq";
  version = "8fd10892f6bc6d219130e8e0b515b7938db039e7";
  src = fetchgit {
    url = "https://github.com/score-p/scorep_plugin_metricq";
    rev = "${version}";
    hash = "sha256-laEocAD7au4mdGFlOJzRpcjWz0Gm0MKKfDJRT3uFkk4=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    protobuf
    scorep
    openssl
  ];
}
