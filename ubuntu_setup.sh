#!/bin/bash

# set scirpt variables
GIT_USER_NAME=m-tartari
GIT_USER_EMAIL=37861893+m-tartari@users.noreply.github.com
SCRIPT_PATH=$(dirname "$(readlink -f "$BASH_SOURCE")")

## define functions used in this script
add_to_file_if_missing () {
  #usage add_to_file_if_missing FILE LINE (COMMENT?)
  if [ $# -eq 3 ]; then
    grep -qxF -- "$2" "$1" || (echo "$3" >> "$1" && echo "$2" >> "$1")
  elif [ $# -eq 2 ]; then
    grep -qxF -- "$2" "$1" || echo "$2" >> "$1"
  else
    echo -e "\033[38;5;178m[warning] add_to_file_if_missing received invalid number of args ($#). Ignoring comand\033[0m"
  fi
}

function loop_reboot() {
  read -p "Should I reboot? [y/N]" prompt
  if [[ $prompt =~ [yY](es)* ]]; then
    sudo reboot
  elif [[ $prompt =~ [nN](o)* ]]; then
    echo -e "\e[1;36m** Enjoy! \e[0m\n"
  else
    loop_reboot
  fi
}


echo -e "\e[1;32m*** Set-up procedure started \e[0m"
source /etc/os-release

### System Update
echo -e "\e[1;36m* Updating system \e[0m"
sudo apt update
sudo apt upgrade -y
sudo apt full-upgrade -y
sudo apt autoremove -y
sudo snap refresh
echo -e "\e[1;36m* Done \e[0m"

### Edit Grub
echo -e "\n\e[1;36m* Modifying GRUB entries \e[0m"
#save last selected os (the command needs to be over 2 lines)
sudo sed -i -e 's/GRUB_DEFAULT=0/GRUB_DEFAULT=saved\
GRUB_SAVEDEFAULT=true/g' /etc/default/grub
sudo update-grub
echo -e "\e[1;36m* Done \e[0m"

### Utilities
echo -e "\n\e[1;36m* Installing utilities \e[0m"

## Terminator
echo -e "\n\e[1;34m** Terminator\e[0m"
read -p "Should I install Terminator? [Y/n]" prompt
if [[ $prompt =~ [yY](es)* ]] || [[ -z $prompt ]]; then
  sudo add-apt-repository ppa:mattrose/terminator
  sudo apt-get update
  sudo apt install terminator
  # set as default
  gsettings set org.gnome.desktop.default-applications.terminal exec /usr/bin/terminator
  gsettings set org.gnome.desktop.default-applications.terminal exec-arg "-x"
  echo -e "\e[1;34m** Done \e[0m"
else
  echo -e "\e[1;34m** Skipped \e[0m"
fi

## Git
echo -e "\n\e[1;34m** Git\e[0m"
read -p "Should I install git? [Y/n]" prompt
if [[ $prompt =~ [yY](es)* ]] || [[ -z $prompt ]]; then
  sudo add-apt-repository ppa:git-core/ppa
  sudo apt install git
  git config --global user.name $GIT_USER_NAME
  git config --global user.email $GIT_USER_EMAIL

  echo -e "\e[1;34m*** GPG key \e[0m"
  read -p "Should I add and configure a new gpg key? [y/N]" prompt
  if [[ $prompt =~ [yY](es)* ]] || [[ -z $prompt ]]; then
    gpg --full-generate-key
    # see https://stackoverflow.com/a/58379307/22225741 for regex explanation
    GPG_KEY_ID=$(gpg --list-secret-keys --keyid-format=long | sed -nr 's/sec\s*\w+\/(\w+).*/\1/p')

    # Prints the GPG key ID, in ASCII armor format
    gpg --armor --export $GPG_KEY_ID
    echo -e '\nCopy the GPG key above (including "-----BEGIN PGP PUBLIC KEY BLOCK-----" and "-----END PGP PUBLIC KEY BLOCK-----") and add it to your github account'
    echo -e 'for details see https://docs.github.com/en/authentication/managing-commit-signature-verification/adding-a-gpg-key-to-your-github-account \n'
    read -p "Once done, press any ENTER to continue. "

    git config --global --unset gpg.format
    git config --global user.signingkey $GPG_KEY_ID
    git config --global commit.gpgsign true

    add_to_file_if_missing ~/.bashrc "export GPG_TTY=\$(tty)" "# for gpg signing in vscode"

    unset GPG_KEY_ID
    echo -e "\e[1;34m*** Done \e[0m"
  else
    echo -e "\e[1;34m*** Skipped \e[0m"
  fi
  echo -e "\e[1;34m** Done \e[0m"
else
  echo -e "\e[1;34m** Skipped \e[0m"
fi

## Cafeine
echo -e "\n\e[1;34m** Cafeine \e[0m"
read -p "Should I install Cafeine? [Y/n]" prompt
if [[ $prompt =~ [yY](es)* ]] || [[ -z $prompt ]]; then
  sudo apt update
  sudo apt install caffeine -y

  # show all startup entry
  sudo sed -i 's/NoDisplay=true/NoDisplay=false/g' /etc/xdg/autostart/*.desktop
  # edit Editing caffeine start-up entry
  sudo sed -i -e "s+Exec=/usr/bin/caffeine+Exec=/usr/bin/caffeine-indicator+g" /etc/xdg/autostart/caffeine.desktop

  echo -e "\e[1;34m** Done \e[0m"
else
  echo -e "\e[1;34m** Skipped \e[0m"
fi

## VLC
echo -e "\n\e[1;34m** VLC \e[0m"
read -p "Should I install VLC? [Y/n]" prompt
if [[ $prompt =~ [yY](es)* ]] || [[ -z $prompt ]]; then
  sudo snap install vlc -y
  echo -e "\e[1;34m** Done \e[0m"
else
  echo -e "\e[1;34m** Skipped \e[0m"
fi
## GParted
echo -e "\n\e[1;34m** GParted \e[0m"
read -p "Should I install GParted? [Y/n]" prompt
if [[ $prompt =~ [yY](es)* ]] || [[ -z $prompt ]]; then
  sudo apt update
  sudo apt install gparted -y
  echo -e "\e[1;34m** Done \e[0m"
else
  echo -e "\e[1;34m** Skipped \e[0m"
fi
## gnome-tweaks
echo -e "\n\e[1;34m** gnome-tweaks \e[0m"
read -p "Should I install gnome-tweaks? [Y/n]" prompt
if [[ $prompt =~ [yY](es)* ]] || [[ -z $prompt ]]; then
  sudo apt update
  sudo apt install gnome-tweaks
  echo -e "\e[1;34m** Done \e[0m"
else
  echo -e "\e[1;34m** Skipped \e[0m"
fi

## WineHQ (windows compatibility layer)
echo -e "\n\e[1;34m** Downloading Wine\e[0m"
sudo mkdir -pm755 /etc/apt/keyrings
sudo wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
sudo wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/$UBUNTU_CODENAME/winehq-$UBUNTU_CODENAME.sources
sudo apt update
sudo apt install --install-recommends winehq-stable
echo -e "\e[1;34m* Done \e[0m"

## Neofetch
echo -e "\n\e[1;34m** Neofetch \e[0m"
read -p "Should I install ? [Y/n]" prompt
if [[ $prompt =~ [yY](es)* ]] || [[ -z $prompt ]]; then
echo -e "\n\e[1;34m** Downloading Neofetch\e[0m"
sudo apt update
sudo apt install neofetch -y
  echo -e "\e[1;34m** Done \e[0m"
else
  echo -e "\e[1;34m** Skipped \e[0m"
fi

### Change Preferences
echo -e "\n\e[1;36m* Changing Preferences\e[0m"
cp -r $SCRIPT_PATH/.bash* ~
# cp -r $SCRIPT_PATH/configs/.config ~
# cp -r $SCRIPT_PATH/configs/vscode ~/.vscode
# cp -r $SCRIPT_PATH/.ssh ~/.ssh
# cp -r $SCRIPT_PATH/Documents/* ~/Documents/
cp -r $SCRIPT_PATH/Pictures/* ~/Pictures/
# cp -r $SCRIPT_PATH/Videos/* ~/Videos/
# cp -r $SCRIPT_PATH/apps ~
echo -e "\e[1;34m* Done \e[0m"

### cleanup script variables
unset GIT_USER_NAME
unset GIT_USER_EMAIL

### print system info and ecommend reboot
echo -e "\n\e[1;32m*** Done \e[0m(reboot recommend)"
echo -e "\n\e[1;34m* System info:\e[0m\n"
neofetch || sudo dmidecode -t system

loop_reboot
exit 0
