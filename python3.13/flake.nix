{
  description = "Universal Python 3.13 Environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "aarch64-darwin";
      pkgs = import nixpkgs { inherit system; };

      python = pkgs.python313.withPackages (p: with p; [
        # requests
        # numpy
      ]);
    in
      {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          python
          pkgs.python313Packages.python-lsp-server
          pkgs.black
          pkgs.isort

          pkgs.uv
        ];
        shellHook = ''
          if [ ! -d ".venv" ]; then
            echo "Creating virtual environment with uv..."
            uv venv
          fi
          source .venv/bin/activate

          if [ -f "requirements.txt" ]; then
            echo "Installing dependencies from requirements.txt..."
            uv pip install -r requirements.txt
          fi

          echo "Python 3.13 Environment Ready !"
        '';
      };
    };
}
