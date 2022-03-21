{ pkgs, stdenv, lib, ocamlPackages, static ? false, doCheck }:

with ocamlPackages;
rec {
  ocamltest = buildDunePackage {
    pname = "ocamltest";
    version = "0.1.0";

    src = lib.filterGitSource {
      src = ./..;
      dirs = [ "bin" "lib" ];
      files = [ "dune-project" "ocamltest.opam" ];
    };
    # dune build . --display=short --profile=${if static then "static" else "release"}
    # Static builds support, note that you need a static profile in your dune file
    buildPhase = ''
      echo "running ${if static then "static" else "release"} build"
      echo $(pwd)
      echo ls
      dune build -p ocamltest
    '';
    installPhase = ''
      mkdir -p $out/bin
      mv _build/default/bin/main.exe $out/bin/ocamltest
    '';

    checkInputs = [
    ];

    propagatedBuildInputs = [
      piaf
      lwt
      yojson
    ];

    inherit doCheck;

    meta = {
      description = "Your main";
    };
  };
}
