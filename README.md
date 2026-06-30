# nix-templates

## usage

### temporary

```sh
cd project
nix develop ~/nix-templates/<envname> -c zsh
```

### permanent

```sh
cd project
echo "source_env_if_exists .envrc.local" > .envrc
echo "use flake ~/nix-templates/<envname>" > .envrc.local
direnv allow
```
