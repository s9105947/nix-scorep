{
  description = "Score-P measurement infrastructure";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11"; 

  outputs = { self, nixpkgs }:
    {
      packages.x86_64-linux =
        let
          pkgs = import nixpkgs { system = "x86_64-linux"; };
          selfpkgs = self.packages.x86_64-linux;
          majorminor = version:
            pkgs.lib.strings.concatStringsSep "."
              (pkgs.lib.lists.sublist 0 2
                (pkgs.lib.strings.splitString "." version));
        in {
          opari2 = pkgs.stdenv.mkDerivation rec {
            pname = "opari2";
            version = "2.0.8";
            src = pkgs.fetchurl {
              url = "https://perftools.pages.jsc.fz-juelich.de/cicd/${pname}/tags/${pname}-${version}/${pname}-${version}.tar.gz";
              sha256 = "sha256-GW5ZoqYl5seVphJMYeeEutFC+fON8LT6TUNbqbnBlyE=";
            };
            nativeBuildInputs = [pkgs.which];
            propagatedBuildInputs = [pkgs.gawk];
            doCheck = true;
            enableParallelBuilding = true;
          };
          cubew = pkgs.stdenv.mkDerivation rec {
            pname = "cubew";
            version = "4.8.2";
            src = pkgs.fetchurl {
              url = "http://apps.fz-juelich.de/scalasca/releases/cube/${majorminor version}/dist/${pname}-${version}.tar.gz";
              sha256 = "sha256-TzvPBiLCQpuJcrXrPxTXnsibgWHjwcxYYs7aQX15ddI=";
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
            version = "4.8.2";
            src = pkgs.fetchurl {
              url = "http://apps.fz-juelich.de/scalasca/releases/cube/${majorminor version}/dist/${pname}-${version}.tar.gz";
              sha256 = "sha256-1v3vV7G8lZTxRQukbPCPQx3Q1K5ZXEfi80VOF+SudPQ=";
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
            version = "3.0.3";
            src = pkgs.fetchurl {
              url = "https://perftools.pages.jsc.fz-juelich.de/cicd/${pname}/tags/${pname}-${version}/${pname}-${version}.tar.gz";
              sha256 = "sha256-GKOQX3kXNAOH4+3I5XZvMasa9B9OzFZl2mx2nKIcTug=";
            };
            enableParallelBuilding = true;
            buildInputs = [
              (pkgs.python3.withPackages (ps: [ps.six]))
            ];
          };
          otf2-python = pkgs.python3.pkgs.toPythonModule selfpkgs.otf2;
          scorep = pkgs.stdenv.mkDerivation rec {
            pname = "scorep";
            version = "8.3";
            src = pkgs.fetchurl {
              url = "http://perftools.pages.jsc.fz-juelich.de/cicd/${pname}/tags/${pname}-${version}/${pname}-${version}.tar.gz";
              sha256 = "sha256-dskU5jGSIcBZI0WXo7xT2niO1nkXmsmcFHKE3O+xV0o=";
            };
            propagatedBuildInputs = (with pkgs; [gcc]) ++ (with selfpkgs; [opari2 cubew cubelib otf2]);
            buildInputs = with pkgs; [ libbfd_2_38 ];

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
            paths = with selfpkgs; [scorep otf2 cubelib cubew opari2] ++
              [(pkgs.python3.withPackages (ps: [ps.six selfpkgs.otf2-python]))];
          };
        };

      defaultPackage.x86_64-linux = self.packages.x86_64-linux.scorep-env;
    };
}
