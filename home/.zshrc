while read file
do 
  source "$ZDOTDIR/$file.zsh"
done <<-EOF
theme
env
aliases
utility
options
plugins
keybinds
prompt
EOF

# vim:ft=zsh:nowrap
eval "$(zoxide init zsh)"
