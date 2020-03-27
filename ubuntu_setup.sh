#!/bin/bash
echo -e "\e[1;32m*** Set-up procedure started \e[0m"
script_path=$(dirname "$(readlink -f "$BASH_SOURCE")")

### System Update
echo -e "\e[1;36m** Updating system \e[0m"
sudo apt update
sudo apt upgrade -y
sudo apt full-upgrade -y
echo -e "\e[1;36m** Done \e[0m"

### Utilities
echo -e "\n\e[1;36m* Installing utilities \e[0m"
sudo apt install vlc -y
sudo apt install gparted -y 
# Terminator
echo -e "\n\e[1;34m* Downloading Terminator\e[0m"
sudo apt install terminator -y
cp $script_path/pictures/terminator-debian-wallpaper.jpg ~/Pictures/terminator-debian-wallpaper.jpg
sudo cp -r $script_path/config/terminator/ /home/$(whoami)/.config/terminator/
sed -i -e "s+/home/user/Pictures/terminator-debian-wallpaper.jpg+/home/$(whoami)/Pictures/terminator-debian-wallpaper.jpg+g" /home/$(whoami)/.config/terminator/config
echo -e "\e[1;36m* Done \e[0m"
## Cafeine
echo -e "\n\e[1;34m* Downloading Caffeine\e[0m"
sudo apt install caffeine -y
# edit Editing caffeine start-up entry: in ~/.config/autostart/caffeine.desktop replace Exec=/usr/bin/caffeine  with Exec=/usr/bin/caffeine-indicator
sed -i -e "s+Exec=/usr/bin/caffeine+Exec=/usr/bin/caffeine-indicator+g" ~/.config/autostart/caffeine.desktop
echo -e "\e[1;34m* Done \e[0m"
echo -e "\e[1;36m** Done \e[0m"


### Install vscode and extensions
echo -e "\n\e[1;36m* Downloading VSCode\e[0m"
sudo apt install software-properties-common apt-transport-https wget -y
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
sudo apt update
sudo apt install code

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
echo -e "\e[1;34m* Done \e[0m"
sudo cp $script_path/config/vscode/settings.json /home/$(whoami)/.config/Code/User/settings.json
echo -e "\e[1;36m** Done \e[0m"

### Install NordVPN
echo -e "\n\e[1;36m* Downloading NordVPN\e[0m"
sudo wget -qnc https://repo.nordvpn.com/deb/nordvpn/debian/pool/main/nordvpn-release_1.0.0_all.deb
sudo apt update
sudo apt install nordvpn
echo -e "\e[1;36m** Done \e[0m"

### Change theme 
echo -e "\n\e[1;36m* Changing Appearence\e[0m"
cp $script_path/pictures/Debian_background.png ~/Pictures/Debian_background.png
# Change backgorund
gsettings set org.gnome.desktop.background picture-uri "file:///home/$(whoami)/Pictures/Debian_background.png"
# Change launcher position
gsettings set com.canonical.Unity.Launcher launcher-position Bottom
# Change launcer icon size
gsettings set org.compiz.unityshell:/org/compiz/profiles/unity/plugins/unityshell/ icon-size 48
# Replace Favorite apps on launcer
echo -e "current favorite launcer app: $(gsettings get com.canonical.Unity.Launcher favorites)"
echo -e "--> new favorite launcer app: ['application://org.gnome.Nautilus.desktop', 'application://firefox.desktop', 'unity://running-apps', 'application://code.desktop', 'unity://expo-icon', 'unity://devices']"
# the full list of available app can be found at /usr/share/applications/
gsettings set com.canonical.Unity.Launcher favorites "['application://org.gnome.Nautilus.desktop', 'application://firefox.desktop','application://code.desktop','application://code.desktop', 'unity://running-apps', 'unity://expo-icon', 'unity://devices']"

echo -e "\n\e[1;34m* Downloading new themes\e[0m"
sudo add-apt-repository ppa:noobslab/themes
sudo apt-get update
sudo apt-get install unity-tweak-tool arc-theme -y
echo -e "\e[1;34m*Done \e[0m"
echo -e "\n\e[1;34m* Chose a theme \e[0m(I recommend Arc-dark)"

function loop_theme() {
  unity-tweak-tool -a;
  read -p "Did you change the theme? [y/N]" prompt
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