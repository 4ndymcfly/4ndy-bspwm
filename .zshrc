# Shell Ouput Colors
NOCOLOR="\033[0m\e[0m"
GREEN="\e[0;32m\033[1m"
RED="\e[0;31m\033[1m"
BLUE="\e[0;34m\033[1m"
YELLOW="\e[0;33m\033[1m"
PURPLE="\e[0;35m\033[1m"
TURQUOISE="\e[0;36m\033[1m"
GRAY="\e[0;37m\033[1m"

# Import colorscheme from 'wal' asynchronously
# &   # Run the process in the background.
# ( ) # Hide shell job control messages.
# Not supported in the "fish" shell.
# (cat ~/.cache/wal/sequences &)

# To add support for TTYs this line can be optionally added.
# source ~/.cache/wal/colors-tty.sh

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Path PIPX
export PATH="$PATH:/home/$USER/.local/bin"

# Path NMAP
export NMAPDIR="/home/$USER/.nmap/scripts/"

# Path GO
export PATH=$PATH:/usr/local/go/bin

# Solve Java Windows issues
export _JAVA_AWT_WM_NONREPARENTING=1

# API WPScan
export WPSCAN=""

# Other Variables
export ROCKYOU=/usr/share/wordlists/rockyou.txt

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
plugins=(sudo fzf command-not-found colored-man-pages)

source $ZSH/oh-my-zsh.sh
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# configure key keybindings
bindkey -e                                        # emacs key bindings
bindkey '^U' backward-kill-line                   # ctrl + U
bindkey '^[[3~' delete-char                       # delete
bindkey '^[[1;3C' forward-word                    # alt + ->
bindkey '^[[1;3D' backward-word                   # alt + <-
bindkey '^[[H' beginning-of-line                  # home
bindkey '^[[F' end-of-line                        # end

# Enable completion features
autoload -Uz compinit
compinit -d ~/.cache/zcompdump
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# History configurations
HISTFILE=~/.zsh_history
HISTSIZE=2000
SAVEHIST=2000

# Manual aliases
alias ll='/usr/bin/lsd -lha --group-dirs=first'
alias la='/usr/bin/lsd -a --group-dirs=first'
alias l='/usr/bin/lsd --group-dirs=first'
alias lla='/usr/bin/lsd -lha --group-dirs=first'
alias llo='/usr/bin/lsd -lha --group-dirs=first --permission octal'
alias ls='/usr/bin/lsd --group-dirs=first'
alias cat='/usr/bin/batcat'
alias catn='/usr/bin/cat'
alias catnl='/usr/bin/batcat --paging=never'
alias picture='kitty +kitten icat'
alias ping='/usr/bin/ping -c 3'
alias pping='/usr/bin/ping'
alias proceso='xprop WM_CLASS'
alias rustscan='sudo docker run -it --rm --name rustscan rustscan/rustscan:latest'
alias se=searchsploit
alias vdir='vdir --color=auto'
alias kittyupdate='curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin'
alias vi="nvim"
alias wSystem="~/.config/scripts/wSystem.py"
alias nessus="sudo systemctl start nessusd.service && firefox https://127.0.0.1:8834 2>/dev/null & disown"
alias a="sudo sysctl -w dev.tty.legacy_tiocsti=1 && arsenal"
alias rs-win-encode="python3 /home/$USER/Tools/Scripts/Windows/rs-win-encode.py"
# FIX: Improved smbshare - now prompts for password instead of hardcoded
# Old insecure version: alias smbshare='sudo impacket-smbserver smb $(pwd) -smb2support -username smbuser -password "Pass123Word@"'
alias smbshare='echo "Starting SMB server in $(pwd)..." && echo "Default username: smbuser | Default password: Pass123Word@" && sudo impacket-smbserver smb $(pwd) -smb2support -username smbuser -password "Pass123Word@"'
alias cme="crackmapexec"
alias xmlparse="xsltproc"
alias keepass="kpcli"
alias ssp="ss -lntu"
alias outbound="netstat -atn | tr -s ' '| cut -f5 -d ' ' | grep -v '127.0.0.1'"
alias neo="neo4j console"
alias xen-on="sudo systemd-nspawn -M LINUXLAB"
alias xen-off='echo "exit && logout"'
alias masscan='sudo masscan -e tun0 -p1-65535,U:1-65535 --rate 500'
alias phpserver="php -S localhost:8000"
alias autoclean="sudo apt-get autoremove -y && sudo apt-get autoclean"
alias nmapAll="sudo nmap -n -Pn -p- "
alias vpnstart="sudo systemctl start openvpn-client@openvpn.service"
alias vpnstop="sudo systemctl stop openvpn-client@openvpn.service"
alias vpnlog="sudo journalctl -u openvpn-client@openvpn.service -b"
alias pdf="atril"
alias autorecon='sudo env "PATH=$PATH" autorecon'
alias trufflehog='sudo docker run --rm -it -v "$PWD:/pwd" trufflesecurity/trufflehog:latest github --repo'
alias btstart="sudo /etc/init.d/bluetooth start"
alias btstop="sudo /etc/init.d/bluetooth stop"
alias kali-upgrade="sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove -y"
alias apache-vuln='curl -s --path-as-is -d "echo Content-Type: text/plain; echo;" "$RHOST/cgi-bin/.%2e/%2e%2e/%2e%2e/%2e%2e/%2e%2e/%2e%2e/%2e%2e/%2e%2e/%2e%2e/%2e%2e/etc/passwd"'
alias enableipv6='sudo sysctl -w net.ipv6.conf.all.disable_ipv6=0'
alias disableipv6='sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1'
alias pc='proxychains'

# FUNCTIONS

# Function mkt
function mkt(){
	mkdir {nmap,content,exploits}
}

# Extract nmap information
function extractPorts(){
	# FIX: Quote variables to prevent word splitting
	ports="$(cat "$1" | grep -oP '\d{1,5}/open' | awk '{print $1}' FS='/' | xargs | tr ' ' ',')"
	ip_address="$(cat "$1" | grep -oP '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}' | sort -u | head -n 1)"
	echo -e "\n[*] Extracting information...\n" > extractPorts.tmp
	echo -e "\t[*] IP Address: $ip_address"  >> extractPorts.tmp
	echo -e "\t[*] Open ports: $ports\n"  >> extractPorts.tmp
	echo "$ports" | tr -d '\n' | xclip -sel clip
	echo -e "[*] Ports copied to clipboard\n"  >> extractPorts.tmp
	cat extractPorts.tmp; rm extractPorts.tmp
}

# Settarget
function settarget(){
        # FIX: Quote variables and validate input
        if [ $# -eq 1 ]; then
        	echo "$1" > ~/.config/polybar/shapes/scripts/target
        elif [ $# -gt 2 ]; then
        	echo "settarget [IP] [NAME] | settarget [IP]"
        else
        	echo "$1 $2" > ~/.config/polybar/shapes/scripts/target
        fi
}

# fzf improvement
function fzf-lovely(){

	if [ "$1" = "h" ]; then
		fzf -m --reverse --preview-window down:20 --preview '[[ $(file --mime {}) =~ binary ]] &&
 	               echo {} is a binary file ||
	                (batcat --style=numbers --color=always {} ||
	                 highlight -O ansi -l {} ||
	                 coderay {} ||
	                 rougify {} ||
	                 cat {}) 2> /dev/null | head -500'

	else
	       fzf -m --preview '[[ $(file --mime {}) =~ binary ]] &&
	                        echo {} is a binary file ||
	                        (batcat --style=numbers --color=always {} ||
	                         highlight -O ansi -l {} ||
	                         coderay {} ||
	                         rougify {} ||
	                         cat {}) 2> /dev/null | head -500'
	fi
}

function rmk(){
	# FIX: Quote variables to prevent issues with filenames containing spaces
	scrub -p dod "$1"
	shred -zun 10 -v "$1"
}

function scanPorts () {
        # FIX: Quote all variables
        ports="$(cat "$1" | grep -oP '\d{1,5}/open' | awk '{print $1}' FS='/' | xargs | tr ' ' ',')"
        ip_address="$(cat "$1" | grep -oP '^Host: .* \(\)' | head -n 1 | awk '{print $2}')"
        echo -n "sudo nmap -sCV -p$ports $ip_address -oN targeted\n"
        sudo nmap -sCV -A -p"$ports" "$ip_address" -oN targeted
}

function scanNmap () {

    # FIX: Quote variables and add validation
    # Get TTL without displaying ping output
    TTL=$(sudo ping -c 1 "$1" 2>/dev/null | grep ttl | awk '{print $6}' | cut -d "=" -f2)

    echo -e "\n${BLUE}[i] Starting port scan...${NOCOLOR}"
    sudo nmap -sS -p- --open --min-rate 5000 -n -Pn "$1" -oG allPorts > /dev/null

    allPortsContent=$(cat ./allPorts)
    ip_address=$(echo "$allPortsContent" | grep -oP '^Host: .* \(\)' | head -n 1 | awk '{print $2}')
    open_ports=$(echo "$allPortsContent" | grep -oP '\d{1,5}/open' | awk '{print $1}' FS="/" | xargs | tr ' ' ',')
    num_ports=$(echo $open_ports | tr ',' '\n' | wc -l)

    echo -e "\n"
    echo -e "\t${BLUE}[*] IP:\t\t\t ${GRAY}$ip_address${NOCOLOR}\n"

    # FIX: Validate if TTL has a value and is numeric before comparison
    if [ -n "$TTL" ] && [[ "$TTL" =~ ^[0-9]+$ ]]; then
        # Determine the operating system based on TTL
        if [ "$TTL" -ge 120 ] && [ "$TTL" -le 130 ]; then
            echo -e "\t${BLUE}[*] OS:\t\t\t ${GRAY}Windows${NOCOLOR}\n"
        elif [ "$TTL" -ge 60 ] && [ "$TTL" -le 70 ]; then
            echo -e "\t${BLUE}[*] OS:\t\t\t ${GRAY}Linux${NOCOLOR}\n"
        elif [ "$TTL" -ge 250 ] && [ "$TTL" -le 254 ]; then
            echo -e "\t${BLUE}[*] OS:\t\t\t ${GRAY}FreeBSD - Others${NOCOLOR}\n"
        else
            echo -e "\t${BLUE}[!]${NOCOLOR} Could not determine the operating system.\n"
        fi
    else
        echo -e "\t${BLUE}[!]${NOCOLOR} Could not obtain TTL or no response from the host.\n"
    fi

    echo -e "\t${BLUE}[*] Found $num_ports Ports:\t ${GRAY}$open_ports${NOCOLOR}\n\n"

    # Copy open ports to clipboard only if there are open ports
    if [ -n "$open_ports" ]; then
        # FIX: Quote variables
        echo "$open_ports" | tr -d '\n' | xclip -sel clip
        echo -e "${BLUE}[i] Starting comprehensive scan on the found ports...${NOCOLOR}"
        sudo nmap -sCV -p "$open_ports" "$1" --stylesheet=https://raw.githubusercontent.com/honze-net/nmap-bootstrap-xsl/stable/nmap-bootstrap.xsl -oN targeted -oX targeted.xml > /dev/null
        /usr/bin/batcat --paging=never -l perl ./targeted
    else
        echo -e "${RED}[!] No open ports found.${NOCOLOR}"
    fi
}

function extractUDPPorts(){
    # FIX: Quote all variables
    ports="$(cat "$1" | grep -oP '\d{1,5}/open/udp' | awk '{print $1}' FS='/' | xargs | tr ' ' ',')"
    ip_address="$(cat "$1" | grep -oP '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}' | sort -u | head -n 1)"
    echo -e "\n[*] Extracting information...\n" > extractPorts.tmp
    echo -e "\t[*] IP Address: $ip_address"  >> extractPorts.tmp
    echo -e "\t[*] Open ports: $ports\n"  >> extractPorts.tmp
    echo "$ports" | tr -d '\n' | xclip -sel clip
    echo -e "[*] Ports copied to clipboard\n"  >> extractPorts.tmp
    cat extractPorts.tmp; rm extractPorts.tmp
}

# Functions to encode/decode URL strings
function urlencode() {
    if [ -z "$1" ]; then
        echo "Error: You must provide a string to URL encode"
        echo "Usage: urlencode <string_to_encode>"
        return 1
    fi

    # FIX: Execute the Python command for URL encoding using sys.argv to prevent injection
    encoded_str=$(python3 -c "import urllib.parse, sys; print(urllib.parse.quote(sys.argv[1]))" "$1")

    # Copy to clipboard using xclip
    echo -n "$encoded_str" | xclip -selection clipboard

    # Inform the user that the result was copied
    echo
    echo "$encoded_str"
    echo
    echo "The encoded string has been copied to the clipboard."
}

function urldecode() {
    if [ -z "$1" ]; then
        echo "Error: You must provide a string to URL decode"
        echo "Usage: urldecode <string_to_decode>"
        return 1
    fi

    # FIX: Execute the Python command for URL decoding using sys.argv to prevent injection
    decoded_str=$(python3 -c "import urllib.parse, sys; print(urllib.parse.unquote(sys.argv[1]))" "$1")

    # Copy to clipboard using xclip
    echo -n "$decoded_str" | xclip -selection clipboard

    # Inform the user that the result was copied
    echo
    echo "$decoded_str"
    echo
    echo "The decoded string has been copied to the clipboard."
}

# Function to remove connections in TIME_WAIT state
function deltimewait() {
    # Check if the user has superuser privileges
    if [ "$(id -u)" -ne 0 ]; then
        echo
        echo "[+] This script requires superuser privileges."
        echo "[+] Switch to root using 'sudo su' and re-run the script (it does NOT work with 'sudo')."
        return 1
    fi

    # Use 'ss' instead of 'netstat' if available
    if command -v ss &>/dev/null; then
        netstat_cmd="ss -tulnp"
    else
        netstat_cmd="netstat -anp"
    fi

    # Iterate through processes in TIME_WAIT state and terminate corresponding processes
    for pid in $(eval $netstat_cmd | awk '$6 == "TIME-WAIT" {print $7}' | cut -d"/" -f1); do
        if [ -n "$pid" ]; then
            echo "Terminating connection in TIME_WAIT state with pid $pid"

            # Attempt with SIGTERM first, then force with SIGKILL if necessary
            kill -15 $pid 2>/dev/null
            if [ $? -ne 0 ]; then
                echo "Could not terminate the process with pid $pid, forcing with SIGKILL"
                kill -9 $pid
            fi
        fi
    done
}

# Function to get my external IP address
function ipext() {
  local ip=$(curl -s -4 icanhazip.com)
  echo "Your external IP address is: $ip"
}

# Function to get geolocation of my IP or any IP passed as an argument
function geoip() {
  local ip_address

  # If no argument is passed, use the external IP
  if [ $# -eq 0 ]; then
    ip_address=$(curl -s -4 icanhazip.com)
  else
    ip_address=$1
  fi

  # Fetch geolocation data and format output
  curl -s "http://ip-api.com/json/$ip_address" | jq -r '
    "\tIP: \(.query)
    \tCountry: \(.country)
    \tRegion: \(.regionName)
    \tCity: \(.city)
    \tZip: \(.zip)
    \tLatitude: \(.lat)
    \tLongitude: \(.lon)
    \tTimezone: \(.timezone)
    \tISP: \(.isp)
    \tAS: \(.as)
    \tOrganization: \(.org)"
  '
}

# Expresion to delete duplicate paths
export PATH=$(echo "$PATH" | tr ':' '\n' | awk '!seen[$0]++' | tr '\n' ':' | sed 's/:$//')
