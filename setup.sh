#!/usr/bin/bash

# Author: Juan Rivas (aka @r1vs3c)

# Forked and extended by Andrés Lorente (aka @4ndymcfly)

# Colours
GREEN="\e[0;32m\033[1m"
NOCOLOR="\033[0m\e[0m"
RED="\e[0;31m\033[1m"
BLUE="\e[0;34m\033[1m"
YELLOW="\e[0;33m\033[1m"
PURPLE="\e[0;35m\033[1m"
TURQUOISE="\e[0;36m\033[1m"
GRAY="\e[0;37m\033[1m"

# Global variables
dir=$(pwd)
fdir="$HOME/.local/share/fonts"
NORMAL_USER=$(getent passwd 1000 | cut -d: -f1)

trap ctrl_c INT

function ctrl_c(){
	echo -e "\n\n${RED}[!] Exiting...\n${NOCOLOR}"
	exit 1
}

function banner(){
	echo -e "\n${TURQUOISE}              _____            ______"
	sleep 0.05
	echo -e "______ ____  ___  /______      ___  /___________________      ________ ___"
	sleep 0.05
	echo -e "_  __ \`/  / / /  __/  __ \     __  __ \_  ___/__  __ \_ | /| / /_  __ \`__ \\"
	sleep 0.05
	echo -e "/ /_/ // /_/ // /_ / /_/ /     _  /_/ /(__  )__  /_/ /_ |/ |/ /_  / / / / /"
	sleep 0.05
	echo -e "\__,_/ \__,_/ \__/ \____/      /_.___//____/ _  .___/____/|__/ /_/ /_/ /_/    ${NOCOLOR}${YELLOW}(${NOCOLOR}${GRAY}By ${NOCOLOR}${PURPLE}@r1vs3c${NOCOLOR}${YELLOW})${NOCOLOR}${TURQUOISE}"
	sleep 0.05
    	echo -e "                                             /_/${NOCOLOR}"
}

if [ "$NORMAL_USER" == "root" ]; then
    clear
	banner
    echo -e "\n\n${RED}[!] You should not run the script as the root user!\n${NOCOLOR}"
    exit 1
else
    clear
	banner
	echo -e "\n[+] Forked and extended by ${PURPLE}@4ndymcfly${NOCOLOR}\n [+] https://github.com/4ndymcfly/\n"
	sleep 1
    echo -e "\n\n${BLUE}[*] Installing necessary packages for the environment...\n${NOCOLOR}"
    sleep 2
    sudo apt install -y kitty rofi feh xclip ranger i3lock-fancy scrot scrub wmname imagemagick cmatrix htop neofetch python3-pip procps tty-clock fzf bat pamixer flameshot pipx openjdk-24-jdk cupp jq qdirstat docker.io btop nuclei neovim ligolo-ng
    if [ $? != 0 ] && [ $? != 130 ]; then
        echo -e "\n${RED}[-] Failed to install some packages!\n${NOCOLOR}"
        exit 1
    else
        echo -e "\n${GREEN}[+] Done with package installation\n${NOCOLOR}"
        sleep 1.5
    fi
    
	# Install last version of LSD
	FILE_URL="https://github.com/lsd-rs/lsd/releases/download/v1.1.5/lsd_1.1.5_amd64.deb"
	FILE_NAME="lsd.deb"
	wget "$FILE_URL" -O "$FILE_NAME"
	sudo dpkg -i "$FILE_NAME"
	if [ $? != 0 ]; then
        echo -e "\n${RED}[-] Failed to install LSD!\n${NOCOLOR}"
        exit 1
    fi
	sleep 1.5
	rm -f "$FILE_NAME" 2>/dev/null

    # Install Go
    GO_VERSION="1.23.0"
    GO_TAR="go${GO_VERSION}.linux-amd64.tar.gz"
    GO_URL="https://go.dev/dl/${GO_TAR}"

    curl -LO $GO_URL
    if [ $? != 0 ]; then
        echo -e "\n${RED}[-] Failed to download Go!\n${NOCOLOR}"
        exit 1
    fi

    # Remove any existing Go installation
    sudo rm -rf /usr/local/go
    sleep 1.5

    # Extract and copy Go binary
    sudo tar -C /usr/local -xzf $GO_TAR
    if [ $? != 0 ]; then
        echo -e "\n${RED}[-] Failed to extract Go!\n${NOCOLOR}"
        exit 1
    fi

    # Remove tar
    rm -f $GO_TAR
    if [ $? != 0 ]; then
        echo -e "\n${RED}[-] Failed to remove Go .tar!\n${NOCOLOR}"
        exit 1
    fi
fi
 
	echo -e "\n${BLUE}[*] Starting installation of necessary dependencies for the environment...\n${NOCOLOR}"
	sleep 0.5

	echo -e "\n${PURPLE}[*] Installing necessary dependencies for bspwm...\n${NOCOLOR}"
	sleep 2
	sudo apt install -y build-essential git vim libxcb-util0-dev libxcb-ewmh-dev libxcb-randr0-dev libxcb-icccm4-dev libxcb-keysyms1-dev libxcb-xinerama0-dev libasound2-dev libxcb-xtest0-dev libxcb-shape0-dev libuv1-dev
	if [ $? != 0 ] && [ $? != 130 ]; then
		echo -e "\n${RED}[-] Failed to install some dependencies for bspwm!\n${NOCOLOR}"
		exit 1
	else
		echo -e "\n${GREEN}[+] Done\n${NOCOLOR}"
		sleep 1.5
	fi

	echo -e "\n${PURPLE}[*] Installing necessary dependencies for polybar...\n${NOCOLOR}"
	sleep 2
	sudo apt install -y cmake cmake-data pkg-config python3-sphinx libcairo2-dev libxcb1-dev libxcb-util0-dev libxcb-randr0-dev libxcb-composite0-dev python3-xcbgen xcb-proto libxcb-image0-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-xkb-dev libxcb-xrm-dev libxcb-cursor-dev libasound2-dev libpulse-dev libjsoncpp-dev libmpdclient-dev libcurl4-openssl-dev libnl-genl-3-dev
	if [ $? != 0 ] && [ $? != 130 ]; then
		echo -e "\n${RED}[-] Failed to install some dependencies for polybar!\n${NOCOLOR}"
		exit 1
	else
		echo -e "\n${GREEN}[+] Done\n${NOCOLOR}"
		sleep 1.5
	fi

	echo -e "\n${PURPLE}[*] Installing necessary dependencies for picom...\n${NOCOLOR}"
	sleep 2
	sudo apt install -y meson libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-randr0-dev libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev libxcb-xinerama0-dev libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev libpcre2-dev libpcre3-dev libevdev-dev uthash-dev libev-dev libx11-xcb-dev libxcb-glx0-dev
	if [ $? != 0 ] && [ $? != 130 ]; then
		echo -e "\n${RED}[-] Failed to install some dependencies for picom!\n${NOCOLOR}"
		exit 1
	else
		echo -e "\n${GREEN}[+] Done\n${NOCOLOR}"
		sleep 1.5
	fi

	echo -e "\n${BLUE}[*] Starting installation of the tools...\n${NOCOLOR}"
	sleep 0.5
	mkdir ~/tools && cd ~/tools

	echo -e "\n${PURPLE}[*] Installing bspwm...\n${NOCOLOR}"
	sleep 2
	git clone https://github.com/baskerville/bspwm.git
	cd bspwm
	make -j$(nproc)
	sudo make install 
	if [ $? != 0 ] && [ $? != 130 ]; then
		echo -e "\n${RED}[-] Failed to install bspwm!\n${NOCOLOR}"
		exit 1
	else
		sudo apt install bspwm -y
		echo -e "\n${GREEN}[+] Done\n${NOCOLOR}"
		sleep 1.5
	fi
	cd ..

	echo -e "\n${PURPLE}[*] Installing sxhkd...\n${NOCOLOR}"
	sleep 2
	git clone https://github.com/baskerville/sxhkd.git
	cd sxhkd
	make -j$(nproc)
	sudo make install > /dev/null 2>&1
	if [ $? != 0 ] && [ $? != 130 ]; then
		echo -e "\n${RED}[-] Failed to install sxhkd!\n${NOCOLOR}"
		exit 1
	else
		echo -e "\n${GREEN}[+] Done\n${NOCOLOR}"
		sleep 1.5
	fi

	cd ..

	echo -e "\n${PURPLE}[*] Installing polybar...\n${NOCOLOR}"
	sleep 2
	git clone --recursive https://github.com/polybar/polybar
	cd polybar
	mkdir build
	cd build
	cmake ..
	make -j$(nproc)
	sudo make install > /dev/null 2>&1
	if [ $? != 0 ] && [ $? != 130 ]; then
		echo -e "\n${RED}[-] Failed to install polybar!\n${NOCOLOR}"
		exit 1
	else
		echo -e "\n${GREEN}[+] Done\n${NOCOLOR}"
		sleep 1.5
	fi

	cd ../../

	echo -e "\n${PURPLE}[*] Installing picom...\n${NOCOLOR}"
	sleep 2
	git clone https://github.com/ibhagwan/picom.git
	cd picom
	git submodule update --init --recursive
	meson --buildtype=release . build
	ninja -C build
	sudo ninja -C build install > /dev/null 2>&1
	if [ $? != 0 ] && [ $? != 130 ]; then
		echo -e "\n${RED}[-] Failed to install picom!\n${NOCOLOR}"
		exit 1
	else
		echo -e "\n${GREEN}[+] Done\n${NOCOLOR}"
		sleep 1.5
	fi

	cd ..

	echo -e "\n${PURPLE}[*] Installing Oh My Zsh and Powerlevel10k for user $NORMAL_USER ...\n${NOCOLOR}"
	sleep 2
	
	sudo -u $NORMAL_USER sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
	sudo -u $NORMAL_USER git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-/home/$NORMAL_USER/.oh-my-zsh/custom}/themes/powerlevel10k
	
	if [ $? != 0 ] && [ $? != 130 ]; then
		echo -e "\n${RED}[-] Failed to install Oh My Zsh and Powerlevel10k for user $NORMAL_USER!\n${NOCOLOR}"
		exit 1
	else
		echo -e "\n${GREEN}[+] Done\n${NOCOLOR}"
		sleep 1.5
	fi

	echo -e "\n${PURPLE}[*] Installing Oh My Zsh and Powerlevel10k for user root...\n${NOCOLOR}"
	sleep 2
	
	sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
	sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /root/.oh-my-zsh/custom/themes/powerlevel10k
	
	if [ $? != 0 ] && [ $? != 130 ]; then
		echo -e "\n${RED}[-] Failed to install Oh My Zsh and Powerlevel10k for user root!\n${NOCOLOR}"
		exit 1
	else
		echo -e "\n${GREEN}[+] Done\n${NOCOLOR}"
		sleep 1.5
	fi

	echo -e "\n${BLUE}[*] Starting configuration of fonts, wallpapers, configuration files, .zshrc, .p10k.zsh, and scripts...\n${NOCOLOR}"
	sleep 0.5

	echo -e "\n${PURPLE}[*] Configuring fonts...\n${NOCOLOR}"
	sleep 2
	if [[ -d "$fdir" ]]; then
		cp -rv $dir/fonts/* $fdir > /dev/null 2>&1
	else
		mkdir -p $fdir
		cp -rv $dir/fonts/* $fdir > /dev/null 2>&1
	fi
	echo -e "\n${GREEN}[+] Done\n${NOCOLOR}"
	sleep 1.5

	echo -e "\n${PURPLE}[*] Copying wallpapers...\n${NOCOLOR}"
	sleep 2
	if [[ -d "~/Wallpapers" ]]; then
		cp -rv $dir/wallpapers/* ~/Wallpapers > /dev/null 2>&1
	else
		mkdir ~/Wallpapers
		cp -rv $dir/wallpapers/* ~/Wallpapers > /dev/null 2>&1
	fi
	
	echo -e "\n${GREEN}[+] Done\n${NOCOLOR}"
	sleep 1.5

	echo -e "\n${PURPLE}[*] Configuring configuration files...\n${NOCOLOR}"
	sleep 2
	cp -rv $dir/config/* ~/.config/ > /dev/null 2>&1
	echo -e "\n${GREEN}[+] Done\n${NOCOLOR}"
	sleep 1.5

	echo -e "\n${PURPLE}[*] Configuring the .zshrc and .p10k.zsh files...\n${NOCOLOR}"
	sleep 2
	cp -v $dir/.zshrc ~/.zshrc
	sudo ln -sfv ~/.zshrc /root/.zshrc
	cp -v $dir/.p10k.zsh ~/.p10k.zsh
	sudo ln -sfv ~/.p10k.zsh /root/.p10k.zsh
	echo -e "\n${GREEN}[+] Done\n${NOCOLOR}"
	sleep 1.5

	echo -e "\n${PURPLE}[*] Configuring scripts...\n${NOCOLOR}"
	sleep 2
	sudo cp -v $dir/scripts/whichSystem.py /usr/local/bin/
	cp -rv $dir/scripts/*.sh ~/.config/polybar/shapes/scripts/
	touch ~/.config/polybar/shapes/scripts/target
	echo -e "\n${GREEN}[+] Done\n${NOCOLOR}"
	sleep 1.5

	echo -e "\n${PURPLE}[*] Configuring necessary permissions and symbolic links...\n${NOCOLOR}"
	sleep 2
	chmod -R +x ~/.config/bspwm/
	chmod +x ~/.config/polybar/launch.sh
	chmod +x ~/.config/polybar/shapes/scripts/*
	sudo chmod +x /usr/local/bin/whichSystem.py
	sudo chmod +x /usr/local/share/zsh/site-functions/_bspc
	sudo chown root:root /usr/local/share/zsh/site-functions/_bspc
	sudo mkdir -p /root/.config/polybar/shapes/scripts/
	sudo touch /root/.config/polybar/shapes/scripts/target
	sudo ln -sfv ~/.config/polybar/shapes/scripts/target /root/.config/polybar/shapes/scripts/target
	sudo systemctl enable docker --now
	sudo usermod -aG docker $NORMAL_USER
	cd ..
	echo -e "\n${GREEN}[+] Done\n${NOCOLOR}"
	sleep 1.5

	echo -e "\n${PURPLE}[*] Pull rustscan Docker image...\n${NOCOLOR}"
	sudo docker pull rustscan/rustscan
	echo -e "\n${GREEN}[+] Done\n${NOCOLOR}"
	sleep 2

	echo -e "\n${PURPLE}[*] Install Arsenal...\n${NOCOLOR}"
	sudo -u $NORMAL_USER pipx install arsenal-cli
	echo -e "\n${GREEN}[+] Done\n${NOCOLOR}"
	sleep 2

	echo -e "\n${PURPLE}[*] Removing repository and tools directory...\n${NOCOLOR}"
	sleep 2
	rm -rfv ~/tools 2>/dev/null
	rm -rfv $dir
	echo -e "\n${GREEN}[+] Done\n${NOCOLOR}"
	sleep 1.5

	echo -e "\n${GREEN}[+] Environment configured :D\n${NOCOLOR}"
	sleep 1.5

	while true; do
		echo -en "\n${YELLOW}[?] It's necessary to restart the system. Do you want to restart the system now? ([y]/n) ${NOCOLOR}"
		read -r
		REPLY=${REPLY:-"y"}
		if [[ $REPLY =~ ^[Yy]$ ]]; then
			echo -e "\n\n${GREEN}[+] Restarting the system...\n${NOCOLOR}"
			sleep 1
			sudo reboot
		elif [[ $REPLY =~ ^[Nn]$ ]]; then
			exit 0
		else
			echo -e "\n${RED}[!] Invalid response, please try again\n${NOCOLOR}"
		fi
	done
fi
