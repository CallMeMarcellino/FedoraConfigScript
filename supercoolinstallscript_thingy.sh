#!/usr/bin/env bash

# Removing then useless bloat:
echo 'Removing the useless bloat'
sudo -u $(whoami) dnf remove -y cheese gnome-contact libreoffice-writer libreoffice-calc libreoffice-impress gnome-photos rhythmbox gnome-system-monitor gnome-text-editor gnome-tour totem

# Adding these configuration options to the DNF config:
echo 'Configuring DNF'
echo 'added by $(whoami)
max_parallel_downloads=10
defaultyes=True' >> /etc/dnf/dnf.conf

# Do the RPM Fusion configuration:
echo 'Configuring RPM Fusion'
dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
dnf groupupdate -y core
dnf groupupdate -y multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
dnf groupupdate -y sound-and-video
dnf install -y rpmfusion-free-release-tainted
dnf install -y libdvdcss
dnf install -y rpmfusion-nonfree-release-tainted
dnf install -y \*-firmware

# Updates the computer:
echo 'Updating the computer'
dnf update -y
dnf upgrade -y

# Adding Flatpak repos:
echo 'Adding the Flathub repositories to Flatpak'
sudo -u $(whoami) flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sudo -u $(whoami) flatpak remote-add --user --if-not-exists flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo

# Installing cool packages:
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

dnf install -y vlc steam gnome-tweaks helvum easyeffects wine bottles pipewire0.2-libs pipewire-doc pipewire-plugin-libcamera papirus-icon-theme util-linux-user discord code git gh
flatpak install com.mattjakeman.ExtensionManager
flatpak install org.polymc.PolyMC
flatpak install net.davidotek.pupgui2

# Replacing Firefox with Google Chrome:
dnf install google-chrome
dnf remove firefox

# Adding Zsh:
dnf install zsh
echo "# Lines added by powerlevel10k
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r '${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh' ]]; then
  source '${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh'
fi
source ~/powerlevel10k/powerlevel10k.zsh-theme
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
# End of lines added by powerlevel10k

# Lines configured by zsh-newuser-install
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

# Adding Powerlevel10k:
sudo -u $(whoami) git clone https://github.com/romkatv/powerlevel10k-media/

mv powerlevel10k-media/"MesloLGS NF Regular.ttf" /usr/local/share/fonts
mv powerlevel10k-media/"MesloLGS NF Bold.ttf" /usr/local/share/fonts
mv powerlevel10k-media/"MesloLGS NF Italic.ttf" /usr/local/share/fonts
mv powerlevel10k-media/"MesloLGS NF Bold Italic.ttf" /usr/local/share/fonts

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k

# Ending:

echo "

Now you can install any gnome extension(s) that you would want through Extension's manager!
I recommend that you first open the Software application and diable the 'Fedora Flatpaks' repository, since you don
t need it.
You might also find it nice to install the RPMSphere repositories.

Lastly, if you want to install any terminal color schemes just run bash -c  '$(wget -qO- https://git.io/vQgMr)'.
PS: The Next time you open a terminal, you'll be met with the Powerlevel10k configuration tool. Therefore, you should try making MesloLGS NF as your default font in Gnome Terminal.
"