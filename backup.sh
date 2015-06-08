cp ~/.config/awesome/rc.lua ~/repo/archBak/config/awesome/rc.lua
cp ~/.config/awesome/sound.sh ~/repo/archBak/config/awesome/sound.sh
cp ~/.config/awesome/ones.sh ~/repo/archBak/config/awesome/ones.sh
cp ~/.config/awesome/dual.sh ~/repo/archBak/config/awesome/dual.sh
cp ~/.bashrc ~/repo/archBak/config/shell/.bashrc
cp ~/.xinitrc ~/repo/archBak/config/shell/.xinitrc
cp ~/.Xresources ~/repo/archBak/config/shell/.Xresources
cp ~/.bash_profile ~/repo/archBak/config/shell/.bash_profile
cp ~/repo/8812au.sh ~/repo/archBak/config/shell/8812au.sh
cp ~/.emacs.d/init.el ~/repo/archBak/config/emacs/init.el
cp ~/.mplayer/config ~/repo/archBak/config/mplayer/config
cp /etc/vimrc ~/repo/archBak/config/vim/vimrc
cp ~/.xpdfrc ~/repo/archBak/config/xpdf/.xpdfrc
pacman -Qqen > ~/repo/archBak/pkglist.txt
pacman -Qemq > ~/repo/archBak/aurlist.txt
