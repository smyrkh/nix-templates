# nix-templates

## usage

### temporary

```
% cd project
% nix develop ~/nix-templates/{envname} -c zsh
```

### permanent

```
% cd project
% echo "use flake ~/nix-templates/{envname}" > .envrc
% direnv allow
```

