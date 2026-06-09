# nix-templates

## usage

### temporary

```sh
cd project
nix develop ~/nix-templates/{envname} -c zsh
```

### permanent

```sh
cd project
echo "use flake ~/nix-templates/{envname}" > .envrc
direnv allow
```
