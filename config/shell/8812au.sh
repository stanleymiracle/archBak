cd ~/repo/rtl8812au/

make

sudo make install

sudo modprobe 8812au

sudo depmod -a

sudo modprobe 8812au

sudo wifi-menu enp0s20u2