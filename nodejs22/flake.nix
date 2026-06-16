{
  description = "Universal Node.js 22 Environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "aarch64-darwin";
      pkgs = import nixpkgs { inherit system; };
    in
      {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          pkgs.nodejs_22
          pkgs.typescript-language-server
          pkgs.vscode-langservers-extracted
        ];
        shellHook = ''
            if [ -f "package.json" ] && [ ! -d "node_modules" ]; then
              echo "📦 Installing dependencies from package.json..."
              npm install
            fi

            echo "🟢 Node.js $(node -v) Environment Ready!"
        '';
      };
    };
}
