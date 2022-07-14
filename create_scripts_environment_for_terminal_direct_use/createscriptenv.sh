#!/bin/bash
# Create color functions for text colors
RED='\033[1;31m'
GREEN='\033[0;32m'
BROWN='\033[0;33m'
BLUE='\033[0;34m'
BWHITE='\033[1;37m'
NC='\033[0m' # No Color

function red {
    printf "${RED}$@${NC}\n"
}

function green {
    printf "${GREEN}$@${NC}\n"
}

function brown {
    printf "${BROWN}$@${NC}\n"
}

function blue {
    printf "${BLUE}$@${NC}\n"
}

function bwhite {
    printf "${BWHITE}$@${NC}\n"
}

echo $(green 'Scripts environment creation v0.1a by github.com/SoulInfernoDE')

#check if .scripts folder exists already in ~/
FILE=~/.scripts
if [ -d "$FILE" ]; then
    echo $(red "$FILE already exists. Exiting.")
    exit
else
    echo $(green "$FILE does not exist and will be created now.") #If the .scripts folder doesn't exist we create it and link it in the ~/.bashrc file. So we can type the script name whenever we want to when placed in ~/.scripts..
    mkdir ~/.scripts
    echo ""
    echo $(blue "Done. Linking the .scripts folder to your Terminal|Bash ..")
    echo export 'PATH=$PATH":$HOME/.scripts"' >>~/.bashrc
    echo "You can now directly use self-made scripts by typing the file name. For example: $(green 'cfs_noguimerge.sh')"
    echo "This enables you to use scripts more frequently without searching for them again. Make sure you copied them to"
    echo $(blue $HOME/.scripts) 'and make them executable if not already done:' $(bwhite 'sudo chmod +x cfsnoguimerge.sh')
fi

# To Do: -- Auto update guard pre-script for updating all my scripts with new versions on github when executed --
#        -- download-menu with this script to choose installation of scripts to your terminal environment for direct installation and use by one shot method--
