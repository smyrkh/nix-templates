{
  description = "Universal Rust Environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    supportedSystems = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
  in {
    devShells = forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        default = pkgs.mkShell {
          packages =
            [
              pkgs.cargo
              pkgs.rustc
              pkgs.rustfmt
              pkgs.clippy

              pkgs.rust-analyzer
              pkgs.cmake
              pkgs.pkg-config
              pkgs.openssl.dev
            ];

          RUST_SRC_PATH = "${pkgs.rustPlatform.rustLibSrc}";

          shellHook = ''
            setup_env() {
              if [ -f "Cargo.toml" ]; then
                echo "Cargo.toml found."
              else
                echo "Cargo.toml not found."
              fi
              echo "Rust Environment Ready !"
              echo "  $(rustc --version)"
              echo "  $(cargo --version)"
            }
            setup_env
          '';
        };
      }
    );
  };
}
