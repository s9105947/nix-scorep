{ stdenv
, fetchgit
, cmake
, scorep
, protobuf
, openssl
, git
}: stdenv.mkDerivation rec {
  pname = "scorep_plugin_metricq";
  version = "c1ff4d787fa6af730f4f8a151da1492618be3556";
  src = fetchgit {
    url = "https://github.com/score-p/scorep_plugin_metricq";
    rev = "${version}";
    hash = "sha256-ZCrgrQdOFGUcwC4sqdYPkG1fm5O7E2P4A2QR+1lmlsI=";
    fetchSubmodules = true;
    deepClone = true;
  };

  nativeBuildInputs = [
    cmake
    git
  ];

  buildInputs = [
    protobuf
    scorep
    openssl
  ];
}
