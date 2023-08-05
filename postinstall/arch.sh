#!/bin/bash

sudo rmmod pcspkr
sudo rmmod snd_pcsp

# Security
sudo echo "ALL: ALL" | sudo tee -a /etc/hosts.deny
sudo echo "
PasswordAuthentication no
MaxAuthTries = 3
" | sudo tee -a /etc/ssh/ssh_config
sudo echo "sshd: ALL: DENY
" | sudo tee -a /etc/hosts.allow

# Start install
sudo echo "[multilib]
Include = /etc/pacman.d/mirrorlist" | sudo tee -a /etc/pacman.conf
sudo pacman -Sy archlinux-keyring --noconfirm
sudo pacman -Syyu --noconfirm
sudo pacman -S base-devel reflector git --noconfirm
sudo reflector --latest 10 --sort rate --save /etc/pacman.d/mirrorlist
sudo systemctl enable --now reflector.timer

# Install yay
mkdir code && cd code
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
cd ../

# Configure yay options
echo y | LANG=C yay --noprovides --answerdiff None --answerclean None --mflags "--noconfirm" $PKGNAME
yay --save --answerclean None --answerdiff None
yay --save --nocleanmenu --nodiffmenu --noconfirm
# Install with yay
yay -S python xdg-utils git github-cli zsh python-pipx alacritty spotify-launcher vulkan-radeon vulkan-icd-loader code python-pip yarn sassc inter-font zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search gh gnome-themes-extra gnome-tweaks gnome-text-editor brainworkshop-git upd72020x-fw linux-firmware-qlogic starship ttf-jetbrains-mono-nerd code-features code-marketplace ttc-iosevka intel-ucode wget nm-connection-editor dnsmasq rust fnm nvim --noconfirm

# Set the default GNOME theme to Adwaita Dark
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'

# Enable minimize and maximize buttons
gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'

# Set general appearance to dark
gsettings set org.gnome.desktop.interface enable-animations true
gsettings set org.gnome.desktop.interface cursor-theme 'Adwaita-dark'
gsettings set org.gnome.desktop.interface icon-theme 'Adwaita'
gsettings set org.gnome.desktop.interface show-battery-percentage false

# Disable screen dimming
gsettings set org.gnome.settings-daemon.plugins.power idle-dim false

# Set screen blank to never
gsettings set org.gnome.settings-daemon.plugins.power idle-brightness 0

# Disable automatic suspend
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type 'nothing'
gsettings set org.gnome.desktop.screensaver timeout 0
gsettings set org.gnome.desktop.session idle-delay 0
gsettings set org.gnome.desktop.privacy disable-camera true
gsettings set org.gnome.desktop.privacy disable-microphone true
gsettings set org.gnome.desktop.screensaver lock-enabled false

curl -fsSL https://get.pnpm.io/install.sh | sh -
source /home/$USER/.zshrc
source /home/$USER/.bashrc
echo 'source /usr/share/nvm/init-nvm.sh' >> ~/.zshrc
echo 'source /usr/share/nvm/init-nvm.sh' >> ~/.bashrc
nvm install node

# Set Super+T shortcut to run term
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'Launch Alacritty'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command 'alacritty'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding '<Super>t'


# Download the "Dash to Dock" extension

cd code
git clone https://github.com/micheleg/dash-to-dock.git

# Move into the extension directory
cd dash-to-dock

# Build and install the extension
make
make install

# Enable the "Dash to Dock" extension
gnome-extensions enable dash-to-dock@micxgx.gmail.com

cd ../../

# Kitty config
kitty
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
echo export RADV_PERFTEST=aco | sudo tee -a /etc/environment

cd /home/$USER
python3 -m venv .venv
source .venv/bin/activate
pip install --upgrade pip

cd code
git clone https://github.com/technicca/dotfiles
sudo cp -a ~/code/dotfiles/home/. ~/
cd ../

chsh -s /bin/zsh
echo "done"
