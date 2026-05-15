# dotfiles

```ps1
winget install twpayne.chezmoi
```

```sh
if [ ! "$(command -v chezmoi)" ]; then
  cd $HOME && sh -c "$(curl -fsSL https://git.io/chezmoi/lb)" -- init --apply $GITHUB_USERNAME # will install .local/bin
  # sh -c "$(curl -fsSL https://git.io/chezmoi)" -- -b "$HOME/.local/bin"
  # wget -qO-
fi
```
```sh
chezmoi init --apply twpayne
chezmoi init --apply --source=$script_dir

# To see tmp output
chezmoi execute-template < dot_zshrc.tmpl
# To clear the state of run_onchange_ scripts, run:
chezmoi state delete-bucket --bucket=entryState
```


