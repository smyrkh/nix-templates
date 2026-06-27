{
  description = "Universal Python 3.13 Environment";

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
            pkgs.python313
            pkgs.uv

            pkgs.python313Packages.python-lsp-server
            pkgs.black
            pkgs.isort

            pkgs.cmake
            pkgs.pkg-config
          ];

          shellHook = ''
            setup_env() {
              if [ -f "pyproject.toml" ]; then
                echo "pyproject.toml found. Syncing environment with uv sync..."
                uv sync
                source .venv/bin/activate
                echo "Python 3.13 Environment Ready !"
                return
              fi

              if [ ! -d ".venv" ]; then
                echo ".venv not found. Creating virtual environment with uv venv..."
                uv venv
              fi
              source .venv/bin/activate

              echo "Installing default packages..."
              uv pip install \
                pwntools \
                pycryptodome

              if [ -f "requirements.txt" ]; then
                echo "requirements.txt found. Installing dependencies from requirements.txt..."
                uv pip install -r requirements.txt
              fi

              echo "Python 3.13 Environment Ready !"
            }
            setup_env
          '';
        };
      }
    );
  };
}
