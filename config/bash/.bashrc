#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

# modify command
alias la='ls -a'
alias ll='ls -al'
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

