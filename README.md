# dotfiles
winget install twpayne.chezmoi

```console
$ chezmoi init twpayne
```


chezmoi execute-template < dot_zshrc.tmpl

To clear the state of run_onchange_ scripts, run:

chezmoi state delete-bucket --bucket=entryState
To clear the state of run_once_ scripts, run:

chezmoi state delete-bucket --bucket=scriptState