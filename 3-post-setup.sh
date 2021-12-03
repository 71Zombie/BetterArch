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
-------------------------------------------------------------------------

Final Setup and Configurations
GRUB EFI Bootloader Install & Check
"
if [[ -d "/sys/firmware/efi" ]]; then
    grub-install --efi-directory=/boot ${DISK}
fi
grub-mkconfig -o /boot/grub/grub.cfg

echo -ne "
-------------------------------------------------------------------------
                    Enabling Login Display Manager
-------------------------------------------------------------------------
"
systemctl enable sddm.service
echo -ne "
-------------------------------------------------------------------------
                    Setting up SDDM Theme
-------------------------------------------------------------------------
"
cat <<EOF > /etc/sddm.conf
[Theme]
Current=Nordic
EOF

echo -ne "
-------------------------------------------------------------------------
                    Hardening Kernel & Firewall
-------------------------------------------------------------------------
"
ufw limit 22/tcp
ufw default deny incoming
ufw default allow outgoing
sudo cp fail2ban.local /etc/fail2ban/
sysctl kernel.modules_disabled=1
sysctl -a
sysctl -A
sysctl mib
sysctl net.ipv4.conf.all.rp_filter
sysctl -a --pattern 'net.ipv4.conf.(eth|wlan)0.arp'

cat <<EOF > /etc/host.conf
order bind,hosts
multi on
EOF

echo -ne "
-------------------------------------------------------------------------
                    Enabling Essential Services
-------------------------------------------------------------------------
"
systemctl enable cups.service
ntpd -qg
systemctl enable ntpd.service
systemctl disable dhcpcd.service
systemctl stop dhcpcd.service
systemctl enable NetworkManager.service
systemctl enable bluetooth
systemctl enable fail2ban

echo -ne "
-------------------------------------------------------------------------
                    SYSTEM READY FOR 4-pen-tools.sh
-------------------------------------------------------------------------
"
exit