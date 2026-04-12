#!/bin/bash

read -p "This is a software bundle. The software bundled with this is called CatBrowser. the catbrowser is made by redcat243. Do you want to proceed? (y/n) " -n 1 -r

# --- 2. CHECK AND INSTALL HOMEBREW ---
echo "Checking for Homebrew..."
if ! command -v brew &> /dev/null; then
    echo "Homebrew not found. Installing..."
    # Non-interactive Homebrew install
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add brew to PATH for this session
    eval "$(/usr/local/bin/brew shellenv)"
else
    echo "Homebrew is already installed."
    # Ensure PATH is set for brew
    eval "$(/usr/local/bin/brew shellenv)"
fi

# --- 2. SPACE FOR HOMEBREW COMMANDS ---
echo "Running Brew Package Commands..."
# Insert required homebrew commands here (e.g., brew install wget)
brew tap redcat243/catbrowser
brew install --cask redcat243/catbrowser/catbrowser

# --- 3. REQUIRE ADMIN ACCESS ---
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root. Please enter your password."
   sudo "$0" "$@"
   exit $?
fi

# --- 4. CHECK AND TURN OFF SYSTEM PROTECTIONS ---
echo "Checking System Protections..."
# Disable Gatekeeper (Allows apps from anywhere)
spctl --master-disable
# Note: Full SIP disabling requires reboot; this helps with app installation
echo "System protections updated."

# --- 5. SPACE FOR DOCK MOD/OTHER COMMANDS ---
echo "Running Dock Modification Commands..."
# Insert your non-silicon native commands here
mkdir -p ~/livemmount
mount_apfs -o nobrowse,rw /dev/disk1s5 ~/livemount                                
# Triggers a GUI popup that pauses the script until "Continue" is clicked
    read -p "Please disable all Mac system protections before proceeding. Once done, click Continue. to do it reboot your mac into recovery mode and click utilites -> terminal and run these 2 commands: csrutil disable and csrutil authenticated-root disable"
# After the user clicks "Continue", the script will resume execution
read -p "THIS WILL MODIFY SYSTEM FILES. DO YOU WANT TO PROCEED? (y/n) " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Proceeding with system modifications..."
else
    echo "Installation aborted by user."
    exit 1
fi
read -p "if your Dock dissapears after the reboot, your origanal Dock is in your home folder, Or you can run the script again"
cp ~/livemount/System/Library/Coreservices/Dock.app ~/
rm -rf ~/livemount/System/Library/Coreservices/Dock.app
cp ~/Desktop/Dock.app ~/livemount/System/Library/CoreServices/
echo "now makeing the Dock Mod permanent"
bless --folder ~/livemount/System/Library/CoreServices --bootefi --create-snapshot
read -p "The system will now reboot to apply changes. Do you want to reboot now? (y/n) " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Rebooting now..."
else
    echo "Please remember to reboot your system as soon as possible to apply the changes."
    exit 0
fi
echo "if you want to undo the dock mod, just run the script again and copy your original dock to your desktop and then run the script again"
echo "if you want... you can install AquaLickX to get a more retro feel on your mac"
echo "Installation Complete. rebooting now..."
reboot
exit 0
