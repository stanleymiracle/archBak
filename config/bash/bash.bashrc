#
# /etc/bash.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='[\u@\h \W]\$ '
PS2='> '
PS3='> '
PS4='+ '

# modify command
alias la='ls -a'
alias lal='ls -al'
alias vi='vim'
alias suvi='sudo vim'
alias audio='sudo alsamixer'
alias wifi='sudo wifi-menu'
alias wifis='iw dev wlp1s0 link'
alias off='sudo poweroff'
alias rst='sudo reboot'

# pacman tips
alias pacman='sudo pacman'
alias pacupg='sudo pacman -Syyu'
alias pacin='sudo pacman -S'
alias pacins='sudo pacman -U'
alias pacre='sudo pacman -R'
alias pacrem='sudo pacman -Rns'
alias pacrep='pacman -Si'
alias pacreps='pacman -Ss'
alias pacloc='pacman -Qi'
alias paclocs='pacman -Qs'
alias paclo='pacman -Qdt'
alias pacc='sudo pacman -Scc'
alias paclf='pacman -Ql'


complete -cf sudo
complete -cf man


case ${TERM} in
  xterm*|rxvt*|Eterm|aterm|kterm|gnome*)
    PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"'

    ;;
  screen)
    PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'printf "\033_%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"'
    ;;
esac

[ -r /usr/share/bash-completion/bash_completion   ] && . /usr/share/bash-completion/bash_completion
