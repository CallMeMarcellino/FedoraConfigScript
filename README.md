# Fedora Configuration Script
## A bash script that configures Fedora

### This bash script does everything that I would do after I install Fedora Linux A few things it does are:
* Removing useless bloat
* Installing a few applications that I use.
* Downloading the RPM Fusion repositories.
* Creating the .histfile and .zshrc files.
* Installing Zsh, and configuring .zshrc.
* Installing powerlevel10k.
* ... and so much more!

### Watch it work!
"Here is where I'll put a video of how it works"

### Installation instructions:
1. Clone the repository.
   ```git clone https://github.com/CallMeMarcellino/FedoraInstallScript```
2. Go into the directory.
   ```cd FedoraConfigScript```
3. Make the file executable.
   ```chmod +x installer.sh```
4. Execute the file.
   ```./installer.sh```

### Find a bug?
Report the bug as an issue, make sure to give me as much information as possible!

### Wanna make a suggestion?
Tell me the suggestion using the Issues functionality, make sure to tell me why this should be implemented.

### Known Issues:
* [ ] When the script sometimes uses 'echo' it fails (and even starts running commands that it isn't suppost to).
* [ ] Doesn't prompt user to enter their password (supposed to set shell for root).

### Plans for the future:
* [ ] Automaticly make MesloLGS NF the default font of Gnome Terminal.
* [ ] Automaticly install color schemes.
* [ ] Automaticly disable the 'Fedora Flatpaks' repository.
* [ ] Prompt user and install extenions for them.
* [ ] Open the Powerlevel10k in the current terminal.
