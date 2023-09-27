#!/bin/bash

sudo rmmod pcspkr
sudo rmmod snd_pcsp

# Base gnome appearance
gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'
gsettings set org.gnome.settings-daemon.plugins.power idle-dim false # Disable screen dimming
gsettings set org.gnome.settings-daemon.plugins.power idle-brightness 0 # Screen blank = never

# General appearance = dark
gsettings set org.gnome.desktop.interface enable-animations true
gsettings set org.gnome.desktop.interface show-battery-percentage false

# Disable automatic suspend
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type 'nothing'
gsettings set org.gnome.desktop.screensaver timeout 0
gsettings set org.gnome.desktop.session idle-delay 0
gsettings set org.gnome.desktop.privacy disable-camera true
gsettings set org.gnome.desktop.privacy disable-microphone true
gsettings set org.gnome.desktop.screensaver lock-enabled false

# Start install
sudo sed -i '/#\[multilib\]/,/#Include = \/etc\/pacman.d\/mirrorlist/{s/#//g}' /etc/pacman.conf
sudo pacman -Sy archlinux-keyring --noconfirm
sudo pacman -Syyu --noconfirm
sudo pacman -S base-devel go git --noconfirm

# Install yay
mkdir code
cd code
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
cd ../

# Configure yay options
yay --save --nocleanmenu --nodiffmenu --noeditmenu --cleanafter --removemake --noprovides --answerdiff None --answerclean None
# Install with yay
yay -S --noconfirm python xdg-utils git github-cli zsh python-pipx vulkan-radeon vulkan-icd-loader python-pip yarn sassc inter-font zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search gh gnome-themes-extra gnome-tweaks gnome-text-editor brainworkshop-git upd72020x-fw linux-firmware-qlogic starship ttf-jetbrains-mono-nerd ttc-iosevka intel-ucode wget nm-connection-editor dnsmasq rust mold fnm neovim htop zoxide aur/bibata-cursor-theme-bin reflector noto-fonts-cjk kitty gnome-shell-extension-dash-to-dock vscodium-bin vscodium-bin-marketplace xclip fd obsidian sshuttle qbittorrent android-tools btop   
# c++ libraries
yay -S --noconfirm eigen imgui cmake clang 
# Other programming stuff
yay -S --noconfirm docker mongodb-bin docker-compose tk redis mongosh-bin

# Fonts, cursor and themes
gsettings set org.gnome.desktop.interface icon-theme 'Adwaita'
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
gsettings set org.gnome.desktop.interface font-name 'Inter Light 11'
gsettings set org.gnome.desktop.interface document-font-name 'Inter Regular 11'
gsettings set org.gnome.desktop.wm.preferences titlebar-font 'Inter Regular 11'
gsettings set org.gnome.desktop.interface monospace-font-name 'Iosevka Term Regular 11'
gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Ice'

# Set Super+T shortcut to run Kitty
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'Launch kitty'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command 'kitty'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding '<Super>t'


# Kitty config
echo "
" >> "/home/$USER/.config/kitty/kitty.conf"
echo "font_family monospace" >> "/home/$USER/.config/kitty/kitty.conf"
echo "remember_window_size no" >> "/home/$USER/.config/kitty/kitty.conf"
echo "initial_window_width 840" >> "/home/$USER/.config/kitty/kitty.conf"
echo "initial_window_height 400" >> "/home/$USER/.config/kitty/kitty.conf"
kitty +kitten themes --reload-in=all Ayu
echo "Lines added successfully to /home/$USER/.config/kitty/kitty.conf"

# Other

git config --global user.name "technicca"
git config --global init.defaultBranch main
git config --global --add --bool push.autoSetupRemote true
echo export RADV_PERFTEST=aco | sudo tee -a /etc/environment

cd /home/$USER
python3 -m venv .venv
source .venv/bin/activate
pip install --upgrade pip
fnm install 20

cd code
git clone https://github.com/technicca/dotfiles
sudo cp -a ~/code/dotfiles/home/. ~/
cd ../

chsh -s usr/bin/zsh # change shell to zsh

echo "Do you want to set your GitHub email? (Y/N)"
read git_choice

if [ "$git_choice" == "Y" ] || [ "$git_choice" == "y" ]; then
    echo "Enter your email:"
    read git_email
    
    # Set the git config
    git config --global user.email "$git_email"
    
    echo "GitHub email set successfully!"
else
    echo "GitHub email not set."
fi

echo "Do you want to set up NVchad? (Y/N)"
read nvim_choice
if [ "$nvim_choice" == "Y" ] || [ "nvim_choice" == "y" ]; then
    git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1 && nvim
else
    echo "NVchad no installed."
fi

echo "done"

echo "Running security scripts:"
