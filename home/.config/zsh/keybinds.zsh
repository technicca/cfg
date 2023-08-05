##
## Keybindings
##

bindkey "^D" end-of-line
bindkey "^q" end-of-line
bindkey -s '^K' 'ls^M'
bindkey -s '^F' '_smooth_fzf^M'

bindkey -M viins '\e/' _vi_search_fix
bindkey "\e[3~" delete-char
bindkey "backspace" backward-delete-char
bindkey "^Z" backward-kill-line

bindkey "^[f" forward-word
bindkey "^[b" backward-word

bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word

# vim:ft=zsh:nowrap
