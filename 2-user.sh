#!/usr/bin/env bash
echo -ne "
------------------------------------------------------------------------------------
                                                                          ▄▄
▀███▀▀▀██▄         ██    ██                        ██                    ███
  ██    ██         ██    ██                       ▄██▄                    ██
  ██    ██ ▄▄█▀██████████████  ▄▄█▀██▀███▄███    ▄█▀██▄   ▀███▄███ ▄██▀██ ███████▄
  ██▀▀▀█▄▄▄█▀   ██ ██    ██   ▄█▀   ██ ██▀ ▀▀   ▄█  ▀██     ██▀ ▀▀██▀  ██ ██    ██
  ██    ▀███▀▀▀▀▀▀ ██    ██   ██▀▀▀▀▀▀ ██       ████████    ██    ██      ██    ██
  ██    ▄███▄    ▄ ██    ██   ██▄    ▄ ██      █▀      ██   ██    ██▄    ▄██    ██
▄████████  ▀█████▀ ▀████ ▀████ ▀█████▀████▄  ▄███▄   ▄████▄████▄   █████▀████  ████▄

------------------------------------------------------------------------------------
                    Automated Arch Linux Installer
------------------------------------------------------------------------------------

Installing AUR Softwares
"
# You can solve users running this script as root with this and then doing the same for the next for statement. However I will leave this up to you.

cd ~
git clone "https://aur.archlinux.org/yay.git"
cd ${HOME}/yay
makepkg -si --noconfirm
cd ~
touch "$HOME/.cache/zshhistory"
git clone "https://github.com/ChrisTitusTech/zsh"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/powerlevel10k
ln -s "$HOME/zsh/.zshrc" $HOME/.zshrc
cd ~
mkdir $HOME/.config/fish
cp /root/BetterArch/dotfiles/fish/config.fish $HOME/.config/fish/

yay -S --noconfirm --needed - < /pkg-files/aur-pkgs.txt

echo -ne "
-------------------------------------------------------------------------
                    Building Portsmaster
-------------------------------------------------------------------------
"
mkdir -p /var/lib/portmaster
wget -O /tmp/portmaster-start https://updates.safing.io/latest/linux_amd64/start/portmaster-start
sudo mv /tmp/portmaster-start /var/lib/portmaster/portmaster-start
sudo chmod a+x /var/lib/portmaster/portmaster-start
sudo /var/lib/portmaster/portmaster-start --data /var/lib/portmaster update
sudo /var/lib/portmaster/portmaster-start core
git clone https://github.com/safing/portmaster-packaging/ /tmp/portmaster-packaging
sudo cp /tmp/portmaster-packaging/blob/master/linux/debian/portmaster.service /etc/systemd/system/
sudo systemctl enable --now portmaster

export PATH=$PATH:~/.local/bin
cp -r $HOME/BetterArch/dotfiles/* $HOME/.config/
pip install konsave
konsave -i $HOME/BetterArch/kde.knsv
sleep 1
konsave -a kde

echo -ne "
-------------------------------------------------------------------------
                    SYSTEM READY FOR 3-post-setup.sh
-------------------------------------------------------------------------
"
exit
