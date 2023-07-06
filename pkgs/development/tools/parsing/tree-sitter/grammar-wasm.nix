{ stdenv
, emscripten
, tree-sitter
, lib
}:


{ language
, version
, src
, wasmName
, location ? null
, ...
}@args:

stdenv.mkDerivation ({
  pname = "${language}-grammar-wasm";

  inherit src version;

  nativeBuildInputs = [ emscripten ];

  configurePhase = lib.optionalString (location != null) ''
    cd ${location}
  '';

  buildPhase = ''
    runHook preBuild

    ${tree-sitter}/bin/tree-sitter build-wasm

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp tree-sitter-${wasmName}.wasm $out

    runHook postInstall
  '';
} // removeAttrs args [ "language" "wasmName" "location" ])
