#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
#[[ -z "$TMUX" ]] && exec tmux

if [ "$TERM" = "screen" ] && [ -n "$TMUX" ] && [ -f /usr/lib/python3.5/site-packages/powerline/bindings/bash/powerline.sh ]; then
    source /usr/lib/python3.5/site-packages/powerline/bindings/bash/powerline.sh
fi

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

export VBOX_USB=usbfs

# modify command
alias .='pwd'
alias ..='cd ..'
alias ...='cd ../..'
alias la='ls -a'
alias ll='ls -al'
alias vi='vim'
alias feh='feh -F'
alias suvi='sudo vim'
alias audio='sudo alsamixer'
alias wifi='sudo wifi-menu'
alias wifis='iw dev wlp1s0 link'
alias wifie='sudo wifi-menu wlp0s20u2'
alias wifies='iw dev enp0s20u2 link'
alias off='sudo poweroff'
alias rst='sudo reboot'
alias play='mpv *.flac'
alias copy='rsync -aP'

# pacman tips
alias pacupg='sudo pacman -Syyu'
alias pacin='sudo pacman -S'
alias pacins='sudo pacman -U'
alias pacre='sudo pacman -R'
alias pacrem='sudo pacman -Rns'
alias pacrep='pacman -Si'
alias pacreps='pacman -Ss'
alias pacaur='pacman -Qm'
alias pacloc='pacman -Qi'
alias paclocs='pacman -Qs'
alias paclo='pacman -Qdt'
alias pacc='sudo pacman -Scc'
alias paclf='pacman -Ql'


complete -cf sudo
complete -cf man

# temperary alias
alias cds='cd ~/repo/Scheme/'
alias abk='cd ~/repo/archBak/ && sh backup.sh && git add * && git commit -m "UPDATE" && git push origin master && cd && clear'


