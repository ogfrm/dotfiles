# zoxide
# Keep track of the most frequently used directories.
# Uses a ranking algorithm to navigate to the best match.
# More information: <https://github.com/ajeetdsouza/zoxide>.

# Go to the highest-ranked directory that contains "foo" in the name:
zoxide query foo

# Go to the highest-ranked directory that contains "foo" and then "bar":
zoxide query foo bar

# Start an interactive directory search (requires `fzf`):
zoxide query --interactive

# Add a directory or increment its rank:
zoxide add path/to/directory

# Remove a directory from `zoxide`'s database interactively:
zoxide remove path/to/directory --interactive

# Generate shell configuration for command aliases (`z`, `za`, `zi`, `zq`, `zr`):
zoxide init bash|fish|zsh


#########################################

z .local  chezmoi  # if you visited will match ~/.local/share/chezmoi
case insesitive order is important   chezmoi .local will not match
last item always has to be last folder name (chazmoi)
it will chose the path most weight(frequency recency)

zi  # interactive mode with fzf
z .local ->Tab  opens fzf

zoxide add <dir>   # increase the score
zoxide query <dir> # search
zoxide query -i -l <dor> # shows score
zoxide edit   # you can edit scores 
zoxide init --cmd cd  # will change z-> cd zi->cdi
