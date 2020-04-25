#!/bin/bash
echo -e "\e[1;32m*** Set-up procedure started \e[0m"
# HOME=/home/$(whoami)
SCRIPT_PATH=$(dirname "$(readlink -f "$BASH_SOURCE")")

### System Update
echo -e "\e[1;36m** Updating system \e[0m"
sudo apt update
sudo apt upgrade -y
sudo apt full-upgrade -y
sudo apt autoremove -y
echo -e "\e[1;36m** Done \e[0m"

### Edit Grub
echo -e "\n\e[1;36m** Modifying GRUB entries \e[0m"
  sudo add-apt-repository ppa:danielrichter2007/grub-customizer -y
sudo apt update
sudo apt install grub-customizer -y
#save last selected os (the command needs to be over 2 lines)
sudo sed -i -e 's/GRUB_DEFAULT=0/GRUB_DEFAULT=saved\
GRUB_SAVEDEFAULT=true/g' /etc/default/grub
sudo update-grub
echo -e "\e[1;36m** Done \e[0m"

### Utilities
echo -e "\n\e[1;36m** Installing utilities \e[0m"
sudo apt update
sudo apt install vlc -y
sudo apt install gparted -y 

# Terminator
echo -e "\n\e[1;34m* Downloading Terminator\e[0m"
sudo apt install terminator -y
cp $SCRIPT_PATH/pictures/terminator-debian-wallpaper.jpg ~/Pictures/terminator-debian-wallpaper.jpg
sudo cp -r $SCRIPT_PATH/config/terminator/ $HOME/.config/terminator/
sudo sed -i -e "s+/home/user/Pictures/terminator-debian-wallpaper.jpg+$HOME/Pictures/terminator-debian-wallpaper.jpg+g" $HOME/.config/terminator/config
sudo sed -i -e "s+#force_color_prompt=yes+force_color_prompt=yes+g" $HOME/.bashrc
echo -e "\e[1;34m* Done \e[0m"

## Cafeine
echo -e "\n\e[1;34m* Downloading Caffeine\e[0m"
sudo apt install caffeine -y
#show all startup entry
sudo sed -i 's/NoDisplay=true/NoDisplay=false/g' /etc/xdg/autostart/*.desktop
# edit Editing caffeine start-up entry
sudo sed -i -e "s+Exec=/usr/bin/caffeine+Exec=/usr/bin/caffeine-indicator+g" /etc/xdg/autostart/caffeine.desktop 
echo -e "\e[1;34m* Done \e[0m"

## WineHQ (windows compatibility layer)
echo -e "\n\e[1;34m* Downloading Wine\e[0m"
sudo dpkg --add-architecture i386
wget -qO - https://dl.winehq.org/wine-builds/winehq.key | sudo apt-key add -
#  Ubuntu 16.04 
sudo apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ xenial main'
#  Ubuntu 18.04 
# sudo apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ bionic main'
# sudo add-apt-repository ppa:cybermax-dexter/sdl2-backport
sudo apt update
sudo apt install --install-recommends winehq-stable
echo -e "\e[1;34m* Done \e[0m"

## Install Neofetch
echo -e "\n\e[1;34m* Downloading Neofetch\e[0m"
sudo add-apt-repository ppa:dawidd0811/neofetch -y
sudo apt-get update
sudo apt-get install neofetch -y
echo -e "\e[1;34m* Done \e[0m"
echo -e "\e[1;36m** Done \e[0m"


### Install vscode and extensions
echo -e "\n\e[1;36m** Downloading VSCode\e[0m"
sudo apt install software-properties-common apt-transport-https wget -y
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
sudo apt update
sudo apt install code
echo -e "\n\e[1;34m* Removing double repository entry\e[0m"
# fixes W: Duplicate sources.list entry http://packages.microsoft.com/repos/vscode stable Release
sudo sed -i -e "s+deb+#deb+g" /etc/apt/sources.list.d/vscode.list
echo -e "\e[1;34m* Done \e[0m"

echo -e "\n\e[1;34m* Adding VSCode extesions\e[0m"
code --install-extension ajshort.msg
code --install-extension ajshort.ros
code --install-extension alefragnani.Bookmarks
code --install-extension alefragnani.project-manager
code --install-extension christian-kohler.path-intellisense
code --install-extension DavidAnson.vscode-markdownlint
code --install-extension DotJoshJohnson.xml
code --install-extension eamodio.gitlens
code --install-extension esbenp.prettier-vscode
code --install-extension formulahendry.auto-rename-tag
code --install-extension Gimly81.matlab
code --install-extension ms-python.python
code --install-extension ms-vscode.cpptools
code --install-extension naumovs.color-highlight
code --install-extension pijar.ros-snippets
code --install-extension ritwickdey.LiveServer
code --install-extension Shan.code-settings-sync
code --install-extension streetsidesoftware.code-spell-checker
code --install-extension twxs.cmake
code --install-extension vscode-icons-team.vscode-icons
code --install-extension wayou.vscode-todo-highlight
code --install-extension grapecity.gc-excelviewer
code --install-extension james-yu.latex-workshop
code --install-extension shd101wyy.markdown-preview-enhanced
echo -e "\e[1;34m* Done \e[0m"
sudo cp $SCRIPT_PATH/config/vscode/settings.json $HOME/.config/Code/User/settings.json
echo -e "\e[1;36m** Done \e[0m"

### Install NordVPN
echo -e "\n\e[1;36m** Downloading NordVPN\e[0m"
sudo wget https://repo.nordvpn.com/deb/nordvpn/debian/pool/main/nordvpn-release_1.0.0_all.deb -P $HOME/Downloads/
sudo dpkg -i $HOME/Downloads/nordvpn-release_1.0.0_all.deb
sudo apt update
sudo apt install nordvpn -y
rm -f /home/michele/Downloads/nordvpn-release_1.0.0_all.deb
echo -e "\e[1;36m** Done \e[0m"

### Change theme 
echo -e "\n\e[1;36m* Changing Appearence\e[0m"
cp $SCRIPT_PATH/pictures/Debian_background.png ~/Pictures/Debian_background.png
# Change backgorund
gsettings set org.gnome.desktop.background picture-uri "file://$HOME/Pictures/Debian_background.png"
# Change launcher position
gsettings set com.canonical.Unity.Launcher launcher-position Bottom
# Change launcer icon size
gsettings set org.compiz.unityshell:/org/compiz/profiles/unity/plugins/unityshell/ icon-size 48
# Replace Favorite apps on launcer
echo -e "current favorite launcer app: $(gsettings get com.canonical.Unity.Launcher favorites)"
echo -e "--> new favorite launcer app: ['application://org.gnome.Nautilus.desktop', 'application://firefox.desktop', 'unity://running-apps', 'application://code.desktop', 'unity://expo-icon', 'unity://devices']"
# the full list of available app can be found at /usr/share/applications/
gsettings set com.canonical.Unity.Launcher favorites "['application://org.gnome.Nautilus.desktop', 'application://firefox.desktop','application://code.desktop','application://code.desktop', 'unity://running-apps', 'unity://expo-icon', 'unity://devices']"
# enable natural scroll
gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll true

echo -e "\n\e[1;34m* Downloading new themes\e[0m"
sudo add-apt-repository ppa:noobslab/themes
sudo apt-get update
sudo apt-get install unity-tweak-tool arc-theme -y
echo -e "\e[1;34m*Done \e[0m"
echo -e "\n\e[1;34m* Chose a theme \e[0m(I recommend Arc-dark)"

function loop_theme() {
  unity-tweak-tool -a;
  read -p "Did you chose your favorite theme? [y/N]" prompt
  if ! { [[ $prompt =~ [yY](es)* ]]; }
  then 
    loop_theme
  fi
}
loop_theme
echo -e "\e[1;34m*Done \e[0m"

### Recommend reboot
echo -e "\n\e[1;32m*** Done \e[0m(reboot recommend)"
function loop_reboot() {
  read -p "Should I reboot? [y/N]" prompt
  if [[ $prompt =~ [yY](es)* ]]
  then 
    echo "rebooting"
    sudo reboot
  elif [[ $prompt =~ [nN](o)* ]]
  then
    echo "then I will NOT reboot"
  else
    loop_reboot
  fi
}
loop_reboot

echo -e "\e[1;36m** Setup completed, enjoy! \e[0m\n"
exit 0
