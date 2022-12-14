{
  description = "Score-P measurement infrastructure";

  outputs = { self, nixpkgs }:
    {
      packages.x86_64-linux =
        let
          pkgs = import nixpkgs { system = "x86_64-linux"; };
          selfpkgs = self.packages.x86_64-linux;
        in {
          opari2 = pkgs.stdenv.mkDerivation rec {
            pname = "opari2";
            version = "2.0.6";
            src = pkgs.fetchurl {
              url = "https://perftools.pages.jsc.fz-juelich.de/cicd/${pname}/tags/${pname}-${version}/${pname}-${version}.tar.gz";
              sha256 = "sha256-VZciic5mCAu0hiIRDDGJo26IoSkXY18EmzdoW507vLA=";
            };
            nativeBuildInputs = [pkgs.which];
            propagatedBuildInputs = [pkgs.gawk];
            doCheck = true;
            enableParallelBuilding = true;
          };
          cubew = pkgs.stdenv.mkDerivation rec {
            pname = "cubew";
            version = "4.6";
            src = pkgs.fetchurl {
              url = "http://apps.fz-juelich.de/scalasca/releases/cube/${version}/dist/${pname}-${version}.tar.gz";
              sha256 = "sha256-mf5YznqxMGHr+8NgrtrswoCZowY2xSaaQsDLr1cUmqg=";
            };
            enableParallelBuilding = true;
            configureFlags = [
              "--with-backend-libz=no"
              "--with-frontend-libz=no"
              "--with-compression=no"
            ];
          };
          cubelib = pkgs.stdenv.mkDerivation rec {
            pname = "cubelib";
            version = "4.6";
            src = pkgs.fetchurl {
              url = "http://apps.fz-juelich.de/scalasca/releases/cube/${version}/dist/${pname}-${version}.tar.gz";
              sha256 = "sha256-Nur/p2iNuLkwTJ5Iyl3E7cLLZlOKr0hle5tczXl5OFs=";
            };
            enableParallelBuilding = true;
            # overwrite false-negative check
            ax_cv_cxx_compile_cxx14 = "yes";
            configureFlags = [
              "--with-frontend-libz=no"
              "--with-compression=no"
            ];
          };
          otf2 = pkgs.stdenv.mkDerivation rec {
            pname = "otf2";
            version = "2.3";
            src = pkgs.fetchurl {
              url = "https://perftools.pages.jsc.fz-juelich.de/cicd/${pname}/tags/${pname}-${version}/${pname}-${version}.tar.gz";
              sha256 = "sha256-NpV0KNN8QNNba0UgjwUPtc/iPFTodBiXeKJLDpIZx+M=";
            };
            enableParallelBuilding = true;
          };
          scorep = pkgs.stdenv.mkDerivation rec {
            pname = "scorep";
            version = "7.1";
            src = pkgs.fetchurl {
              url = "http://perftools.pages.jsc.fz-juelich.de/cicd/${pname}/tags/${pname}-${version}/${pname}-${version}.tar.gz";
              sha256 = "sha256-mN6kl5ggAfuC2jQpylVmmykXoIWMcaviz+fNETOB8fc=";
            };
            propagatedBuildInputs = (with pkgs; [gcc]) ++ (with selfpkgs; [opari2 cubew cubelib otf2]);

            enableParallelBuilding = true;

            configureFlags = with selfpkgs; [
              "--with-nocross-compiler-suite=gcc"
              "--enable-gcc-plugin"
              "--without-mpi"
              "--without-shmem"
              "--with-opari2=${opari2}"
              "--with-cubew=${cubew}"
              "--with-cubelib=${cubelib}"
              "--with-otf2=${otf2}"
            ];
          };

          scorep-env = pkgs.symlinkJoin rec {
            name = "scorep-env";
            paths = with selfpkgs; [scorep otf2 cubelib cubew opari2];
          };
        };

      defaultPackage.x86_64-linux = self.packages.x86_64-linux.scorep-env;
    };
}
