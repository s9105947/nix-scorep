{
  description = "Score-P measurement infrastructure";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11"; 

  outputs = { self, nixpkgs }:
    {
      overlays.default = selfpkgs: pkgs: let
        # callPackage including packages provided here
        selfCallPackage = pkgs.lib.customisation.callPackageWith (pkgs // selfpkgs);
      in {
        opari2 = pkgs.callPackage ./opari2.nix {};
        cubew = pkgs.callPackage ./cubew.nix {};
        cubelib = pkgs.callPackage ./cubelib.nix {};
        otf2 = pkgs.callPackage ./otf2.nix {};
        otf2-python = pkgs.python3.pkgs.toPythonModule selfpkgs.otf2;

        scorep = selfCallPackage ./scorep.nix {};
        scorep_no_mpi = selfCallPackage ./scorep.nix { with_mpi = false; };

        scorep_plugin_metricq = selfCallPackage ./scorep_plugin_metricq.nix {};

        scorep-env = pkgs.symlinkJoin rec {
          name = "scorep-env";
          paths = with selfpkgs; [scorep otf2 cubelib cubew opari2] ++
                                 [(pkgs.python3.withPackages (ps: [ps.six selfpkgs.otf2-python]))];
        };
      };

      packages.x86_64-linux =
        let
          pkgs = import nixpkgs { system = "x86_64-linux"; };
          selfpkgs = self.packages.x86_64-linux;
        in self.overlays.default selfpkgs pkgs;

      defaultPackage.x86_64-linux = self.packages.x86_64-linux.scorep-env;
    };
}
