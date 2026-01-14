{
  description = "Word frequency counter benchmark - Python vs Codon vs Go";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        # Codon binary package
        codon = pkgs.stdenv.mkDerivation rec {
          pname = "codon";
          version = "0.17.0";

          src = pkgs.fetchurl {
            url = "https://github.com/exaloop/codon/releases/download/v${version}/codon-linux-x86_64.tar.gz";
            sha256 = "sha256-HCXyApUcAvhVrCgibHXoxZwsi5zISfn9e08b8aWjpkA=";
          };

          nativeBuildInputs = [ pkgs.autoPatchelfHook ];
          buildInputs = with pkgs; [
            stdenv.cc.cc.lib
            zlib
            libffi
            openssl
          ];

          sourceRoot = ".";

          installPhase = ''
            mkdir -p $out
            cp -r codon-deploy/* $out/ 
          '';

          meta = with pkgs.lib; {
            description = "A high-performance, zero-overhead, extensible Python compiler using LLVM";
            homepage = "https://github.com/exaloop/codon";
            # license = licenses.bsl11;  # BSL 1.1 not available in nixpkgs
            platforms = [ "x86_64-linux" ];
          };
        };

      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            codon
            pkgs.python312
            pkgs.go
            pkgs.time
            pkgs.hyperfine  # For benchmarking
          ];

          shellHook = ''
            echo "Word Counter Benchmark Environment"
            echo "==================================="
            echo "Available tools:"
            echo "  - Python: $(python3 --version)"
            echo "  - Go: $(go version)"
            echo "  - Codon: $(codon --version 2>/dev/null || echo 'codon available')"
            echo "  - Hyperfine: for benchmarking"
            echo ""
            echo "Run benchmarks with: ./run_benchmark.sh"
          '';
        };

        packages.default = codon;
      }
    );
}
