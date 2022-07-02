#!/usr/bin/env bash

if [[ -e ${config.sh} ]] then
    source config.sh
fi

# Checking if script is running in root.
if [ "$EUID" -ne 0 ] then
    echo -n "Please run as root (aka use sudo)."
    exit 1
fi

# Starting
printf "You have started Excalian's Fedora Config Script!\n\nWould you like to start the installation (Y/n)? "
read prompt1
printf '\n\n'
if [[ -z ${prompt1} ]] || [[ ${prompt1} == 'n' ]] then
    printf "Okay, I'll boot you out of the script.\n\n"
    exit 1
else if [[ ${prompt} == 'y']]
    printf "I'll get you started right away!\n\n"
fi

# Removing then useless bloat:
printf "Now I'll start removing all the useless bloat.\n\n"
if [[ -z {$packagesToRemove} ]] then
    dnf remove -y git util-linux-user cheese gnome-contact libreoffice-writer libreoffice-calc libreoffice-impress gnome-photos rhythmbox gnome-system-monitor gnome-text-editor gnome-tour totem
else
    dnf remove -y git util-linux-user${packagesToRemove}
fi

# Adding these configuration options to the DNF config:
printf "Next up I'll be configuring the DNF package manager, could you tell me if you've already configured DNF? (y/N) "
if [[-z ${prompt2}]] || [[${prompt2} == 'n']] then
    printf "\n\nGreat! I'll add the configuration right now!"
    if [[ -z ${DNFConfig}]]
    echo "added by $(whoami)
max_parallel_downloads=10
defaultyes=True" >> /etc/dnf/dnf.conf
    else
    echo "$DNFCONFIG" >> /etc/dnf/dnf.conf
else if [[${prompt2} == 'y']] then
    printf "Okay, I'll skip this part then!"
fi

# Updating your computer:
printf "\n\nRight now, I'll update your computer.\n\nThis'll take a while, so please be patient.\n\n"
dnf update -y
dnf upgrade -y

# Installing the RPM Fusion configuration:
printf "\n\nThank you for your patients! Now I'll install the RPM Fusion configuration."
sudo -u $(whoami) dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo -u $(whoami) dnf groupupdate -y core
sudo -u $(whoami) dnf groupupdate -y multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
sudo -u $(whoami) dnf groupupdate -y sound-and-video
sudo -u $(whoami) dnf install -y rpmfusion-free-release-tainted
sudo -u $(whoami) dnf install -y libdvdcss
sudo -u $(whoami) dnf install -y rpmfusion-nonfree-release-tainted
sudo -u $(whoami) dnf install -y \*-firmware

# Adding Flatpak repos:
printf "\n\nNow I'll be adding the Flatpak repositories."
flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak remote-add --user --if-not-exists flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo

# Installing VSCode:
printf "\n\nWould you like me to install VSCode? (y/N) "
read prompt3
if [[prompt3 == 'y']] then
    printf "\n Okay, I will install VSCode right now."
    sudo -u $(whoami) rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo -u $(whoami) sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
    sudo -u $(whoami) dnf install -y code
else
    printf "Okay, I won't install VSCode."
fi

# Now I'll install a few packages:
printf "\n\nNow I'll install a few packages!\n\n"
if [[ -z ${packagesToInstall} ]] then
    sudo -u $(whoami) dnf install -y git util-linux-user vlc steam gnome-tweaks helvum easyeffects wine bottles pipewire0.2-libs pipewire-doc pipewire-plugin-libcamera papirus-icon-theme discord gh
else
    sudo -u $(whoami) dnf install -y git util-linux-user $packagesToInstall
fi
printf "\n\nNow I'll install Flatpak packages."
if [[ -z ${flatpakPackagesToInstall} ]] then
    flatpak install com.mattjakeman.ExtensionManager
    flatpak install org.polymc.PolyMC
    flatpak install net.davidotek.pupgui2
else
    for flatpak in $flatpakPackagesToInstall do
        flatpak install "${flatpak}"
    done
fi

# Replacing Firefox with something else.
if [[ -z $browserToInstall ]] then
    printf "\n\nNow I'll replace Firefox with the package 'google-chrome-stable'."
    sudo -u $(whoami) dnf install google-chrome-stable
    sudo -u $(whoami) dnf remove firefox
else
    printf "\n\nNow I'll replace Firefox with the package '$browserToInstall'."
    sudo -u $(whoami) dnf install $browserToInstall
    sudo -u $(whoami) dnf remove firefox
fi
# Adding Zsh:
printf "\n\nNow I'll be installing ZSH if you configured me to do that."
if [[ $installZSH == True ]] then
    if [[ -z $ZSHRCContents ]] then
        echo "# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=15000
setopt notify
# End of lines configured by zsh-newuser-install

# The following lines were added by compinstall
zstyle :compinstall filename '/home/lino/.zshrc'
autoload -Uz compinit
compinit
# End of lines added by compinstall" >> ~/.zshrc
        sudo -u $(whoami) chsh -s $(which zsh)
    else
        echo $ZSHRCContents >> ~/.zshrc
        sudo -u $(whoami) chsh -s $(which zsh)
fi

# Installing Powerlevel10k (This part has been scrapped, so yeh.):
# cd ~
# sudo -u $(whoami) git clone https://github.com/romkatv/powerlevel10k-media/
# mv powerlevel10k-media/"MesloLGS NF Regular.ttf" /usr/local/share/fonts
# mv powerlevel10k-media/"MesloLGS NF Bold.ttf" /usr/local/share/fonts
# mv powerlevel10k-media/"MesloLGS NF Italic.ttf" /usr/local/share/fonts
# mv powerlevel10k-media/"MesloLGS NF Bold Italic.ttf" /usr/local/share/fonts
# fc-cache -f -v
# git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
# echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc

# Ending:
printf "\n\n Now you're done, it is recommended to restart your PC/Shell and to check out our wiki on what to do next."
