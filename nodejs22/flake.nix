{
  description = "Universal Node.js 22 Environment";

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
            pkgs.nodejs_22

            pkgs.vscode-langservers-extracted
          ];

          shellHook = ''
            export PATH="$PWD/node_modules/.bin:$PATH"

            if [ -f "package.json" ] && [ ! -d "node_modules" ]; then
              echo "📦 Installing dependencies from package.json..."
              npm install
            fi

            echo "🟢 Node.js $(node -v) Environment Ready!"
          '';
        };
      }
    );
  };
}
