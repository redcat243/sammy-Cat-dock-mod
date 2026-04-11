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
    read -p "Please disable all Mac system protections before proceeding. Once done, click Continue. to do it reboot your mac into recovery mode and click utilites -> terminal and run these 2 commands: csrutil disable && csrutil authenticated-root disable"
# Triggers a GUI popup that pauses the script until "Continue" is clicked
    read -p "manual steps : open finder (do you have the dock app from the repo?) go to your home folder,open the new macintosh hd folder go to the system folder then open the coreservices folder the command deleat the app dock then replace the dock with the dock from the repo"
bless --folder ~/livemount/System/Library/CoreServices --bootefi --create-snapshot


echo "Installation Complete."
echo "please restart your computer"
exit 0
