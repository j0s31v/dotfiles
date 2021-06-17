# Basado en los proyectos
#    https://github.com/mattbrictson/dotfiles
#    https://github.com/masasam/dotfiles
#    https://github.com/andrewsardone/dotfiles/blob/master/Makefile
#    https://gist.github.com/prwhite/8168133

SHELL = /bin/bash
CURRENT_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
PATH := $(CURRENT_DIR)/bin:$(PATH)
TMP := $(CURRENT_DIR)/tmp
DOT := $(CURRENT_DIR)/dotfiles

JOB := $(CURRENT_DIR)/job

VAR := $(CURRENT_DIR)/var
LOG := $(CURRENT_DIR)/var/make.log
OUT := $(CURRENT_DIR)/var/output
BKP := $(CURRENT_DIR)/var/backup

APT  := sudo apt
SNAP := sudo synap
NPM  := sudo npm
DPKG := sudo dpkg
export STOW_DIR = $(CURRENT_DIR)

# ======================================================================================================================

default: help
.DEFAULT_GOAL:=help

#COLORS
GREEN  := $(shell tput -Txterm setaf 2)
WHITE  := $(shell tput -Txterm setaf 7)
YELLOW := $(shell tput -Txterm setaf 3)
RESET  := $(shell tput -Txterm sgr0)

TARGET_MAX_CHAR_NUM=30

help: 
	@echo ''
	@echo 'Usage:'
	@echo '  ${YELLOW}make${RESET} ${GREEN}<target>${RESET}'
	@echo ''
	@echo 'Targets:'
	@awk '/^[a-zA-Z\-_0-9]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")-1); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			printf "  ${YELLOW}%-$(TARGET_MAX_CHAR_NUM)s${RESET} ${GREEN}%s${RESET}\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) }' $(MAKEFILE_LIST)

# COLOR OUTPUT ========================================================================================================= 

bold := $(shell tput bold)
sgr0 := $(shell tput sgr0)
red := $'\e[1;31m
grn := $'\e[1;32m
yel := $'\e[1;33m
blu := $'\e[1;34m
mag := $'\e[1;35m
cyn := $'\e[1;36m
end := $'\e[0m

# ======================================================================================================================
# ======================================================================================================================

# Instalación aplicaciones del sistema  ================================================================================
DEPS_PACKAGES  := git git-crypt stow gawk make curl

SYS_PACKAGES   := linux-headers-$(shell uname -r) build-essential openssl htop rsync  
SYS_PACKAGES   += nmap traceroute tcpdump chkrootkit telnet jnettop dnsutils lsof ntpdate vim pwgen   
SYS_PACKAGES   += zsh curl wget tree nano logrotate git ncdu terminator unison-gtk unison unison-all stow
SYS_PACKAGES   += bzip2 gzip unrar unzip rar unace p7zip-full p7zip-rar
SYS_PACKAGES   += dirmngr gnupg apt-transport-https ca-certificates software-properties-common
SYS_PACKAGES   += hddtemp hdparm lm-sensors laptop-mode-tools remmina
SYS_PACKAGES   += gnome-tweaks chrome-gnome-shell seahorse gparted screen
SYS_PACKAGES   += network-manager-openvpn network-manager-openvpn-gnome
SYS_PACKAGES   += aptitude gdebi gdebi-core synaptic ttf-mscorefonts-installer gnupg
 
DEV_PACKAGES   := nodejs npm python2 python3-pip virtualbox git gitk git-crypt rsync jq mysql-client
DEV_PACKAGES   += dia openjdk-11-jdk mysql-workbench-community filezilla fzf dmenu rofi 

USER_PACKAGES  := cheese cheese-common keepassxc cabextract conky conky-all guake woeusb gimp transmission
USER_PACKAGES  += wine winetricks steam zsnes
USER_PACKAGES  += libreoffice libreoffice-l10n-es libreoffice-templates

MEDIA_PACKAGES := ubuntu-restricted-extras vlc moc 

USER_SNAP_PKG  := spotify deadbeef-vs zoom-client skype ramboxpro dukto

DEV_SNAP_PKG   := typora dbeaver-ce phpstorm pycharm-community intellij-idea-community postman gitkraken umbrello

NPM_PACKAGES   := jitter gulp yo grunt grunt-cli bower webpack

PHP_PACKAGES   := php7.4 php7.4-cgi php7.4-cli php7.4-common php7.4-curl php7.4-json php7.4-opcache 
PHP_PACKAGES   += php7.4-readline php7.4-xdebug php7.4-xml

_upgrade-os:
	@printf "\n $(bold) Actualizacion del SO $(end)\n " | tee -a $(LOG)
	@$(APT) update | tee -a $(OUT)

	@printf "\n $(grn) Upgrade del SO $(end)\n " | tee -a $(LOG)
	@$(APT) upgrade -y | tee -a $(OUT)
	
	@printf "\n $(grn) Upgrade dependencias $(end)\n " | tee -a $(LOG)
	@$(APT) dist-upgrade -f -y | tee -a $(OUT)

	@printf "\n $(grn) Update Snap $(end)\n " | tee -a $(LOG)
	@$(SNAP) refresh | tee -a $(OUT)

_clean-os:
	@printf "\n $(bold) Limpiar Paquetes Instalados SO $(end)\n " | tee -a $(LOG)
	@$(APT) autoremove -y | tee -a $(OUT)
	@$(APT) autoclean -y | tee -a $(OUT)

_dependencies-packages: 
	@printf "\n $(bold) Instala dependencias $(end)\n " | tee -a $(LOG)
	@$(APT) install -y $(DEPS_PACKAGES) | tee -a $(OUT)

_system-packages:
	@printf "\n $(bold) Instala herramientas basicas del sistema $(end)\n " | tee -a $(LOG)
	@$(APT) install -y $(SYS_PACKAGES) | tee -a $(OUT)

_user-packages: 
	@printf "\n $(bold) Instala aplicaciones/packetes para modo usuario $(end)\n " | tee -a $(LOG)
	@$(APT) install -y $(USER_PACKAGES) | tee -a $(OUT)
	@$(APT) install -y $(MEDIA_PACKAGES) | tee -a $(OUT)
	@$(SNAP) install $(USER_SNAP_PKG) --classic | tee -a $(OUT)

_dev-packages:
	@printf "\n $(bold) Instala aplicaciones/packetes para modo desarrollo $(end)\n " | tee -a $(LOG)
	@$(APT) install -y $(DEV_PACKAGES) | tee -a $(OUT)
	@$(SNAP) install $(DEV_SNAP_PKG) --classic | tee -a $(OUT)
	@$(NPM) install -g $(NPM_PACKAGES) | tee -a $(OUT)
	
_composer:
	@printf "\n $(bold) Instalación de composer $(end)\n " | tee -a $(LOG)
	@curl -sS https://getcomposer.org/installer -o $(TMP)/composer-setup.php | tee -a $(OUT)
	@php $(TMP)/composer-setup.php --filename=$(TMP)/composer | tee -a $(OUT)
	@rm $(TMP)/composer-setup.php | tee -a $(OUT)
	@mv $(TMP)/composer /usr/local/bin/ | tee -a $(OUT)

_deb-sublime-text:
	@printf "\n $(bold) Instalación de sublime-text $(end)\n " | tee -a $(LOG) 
	@wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
	@echo "deb https://download.sublimetext.com/ apt/stable/" | tee /etc/apt/sources.list.d/sublime-text.list
	@$(APT) update -y | tee -a $(OUT)
	@$(APT) install -y sublime-text dirmngr gnupg apt-transport-https ca-certificates software-properties-common | tee -a $(OUT)

_deb-google-chrome:
	@printf "\n $(bold) Instalación de Google-Chrome $(end)\n " | tee -a $(LOG)
	@curl -sS https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o $(TMP)/google-chrome-stable.deb
	@$(DPKG) -i $(TMP)/google-chrome-stable.deb | tee -a $(OUT)
	@rm $(TMP)/google-chrome-stable.deb | tee -a $(OUT)

#_deb-zoom:
#	@printf "\n $(bold) Instalación de Zoom $(end)\n " | tee -a $(LOG)
#	@curl -sS https://cdn.zoom.us/prod/5.6.22045.0607/zoom_amd64.deb -o $(TMP)/zoom.deb
#	@$(DPKG) -i $(TMP)/zoom.deb | tee -a $(OUT)
#	@rm $(TMP)/zoom.deb | tee -a $(OUT)

#_deb-gitkraken:
#	curl -sS https://release.axocdn.com/linux/gitkraken-amd64.deb -o $(TMP)/gitkraken.deb
#	dpkg -i $(TMP)/gitkraken.deb
#	rm $(TMP)/gitkraken.deb

_deb-php:
	@printf "\n $(bold) Instalación de Google-Chrome $(end)\n " | tee -a $(LOG)
	@$(APT) install software-properties-common | tee -a $(OUT)
	@sudo add-apt-repository ppa:ondrej/php | tee -a $(OUT)
	@$(APT) update | tee -a $(OUT)
	@$(APT) install -y $(PHP_PACKAGES) | tee -a $(OUT)

##@ Install
## Instala las aplicaciones requeridas
install: install-all  

## Instala las aplicaciones requeridas
install-all: _upgrade-os _dependencies-packages _system-packages _user-packages _deb-google-chrome _deb-sublime-text _dev-packages _composer _deb-php _clean-os

## Instala las aplicaciones de desarrollo.
install-develop: _upgrade-os _dependencies-packages _system-packages _dev-packages _composer _deb-sublime-text _deb-php _clean-os

## Instala las aplicaciones del usuario
install-user: _upgrade-os _dependencies-packages _system-packages _user-packages _deb-google-chrome _deb-sublime-text _clean-os

# ======================================================================================================================
# ======================================================================================================================

##@ Backup

## Genera el backup de los archivos de sistema
retrive-system-data:
	apt list --installed > $(BKP)/ubuntu_packages 
	cat /etc/hosts > $(BKP)/hosts 
	cat /etc/fstab > $(BKP)/fstab 
	cat /etc/crypttab > $(BKP)/crypttab 
	php -m > $(BKP)/php_modules 
	npm list -g --depth=0 > $(BKP)/npm.pkg
	crontab -l > $(BKP)/crontab
	#cat /etc/cron.d/crontab-work > $(BKP)/crontab-work
	#cat /etc/cron.d/crontab-user > $(BKP)/crontab-user

# ======================================================================================================================
# ======================================================================================================================

##@ Dotfiles

_dot-backup:
	echo "genera el backup"

_dot-install:
	echo "instala los archivos de configuración"

ifeq ($(shell test -e /etc/hosts && echo -n yes),yes) 
	sudo mv /etc/hosts /etc/hosts.old 
endif
	sudo stow -d $(DOT) -t /etc etc
	stow -d $(DOT) -t $(HOME) bash
	stow -d $(DOT) -t $(HOME) git
	stow -d $(DOT) -t $(HOME) nano
	stow -d $(DOT) -t $(HOME) home
	stow -d $(DOT) -t $(HOME) zsh
	stow -d $(DOT) -t $(HOME) remmina
	stow -d $(DOT) -t $(HOME) ssh
	stow -d $(DOT) -t $(HOME) mysql
	stow -d $(DOT) -t $(HOME) zsnes
	stow -d $(DOT) -t $(HOME)/.config config
	stow -d $(DOT) -t $(HOME)/.config/sublime-text/Packages sublime-text 
	stow -d $(DOT) -t $(HOME)/.config/ gtk
	stow -d $(DOT) -t $(HOME)/.config/ terminator
	

## Configura e instala los archivos dotfiles en el usuario
stow: _dot-backup _dot-install

# ======================================================================================================================
# ======================================================================================================================

