{
  description = "Universal Go Environment";

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
          packages = [
            pkgs.go

            pkgs.gopls
            pkgs.gotools
            pkgs.go-tools
            pkgs.delve
          ];

          shellHook = ''
            echo "Go Environment Ready !"
            echo "  $(go version)"
          '';
        };
      }
    );
  };
}
