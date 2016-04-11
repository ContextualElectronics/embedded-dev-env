
RED='\e[38;05;9m'
GREEN='\e[38;05;10m'
YELLOW='\e[38;05;11m'
BLUE='\e[38;05;12m'
PURPLE='\e[38;05;13m'
CYAN='\e[38;05;14m'
NC='\e[0m' # No Color

print_message () {
    local message="$1"
    printf "\n${YELLOW}**** ${message} ****${NC}\n"
}

print_error () {
    local message="$1"
    printf "\n${PURPLE}>>>> ${message} <<<<${NC}\n"
}

print_note () {
    local message="$1"
    printf "\n${BLUE}#### ${message} ####${NC}\n"
}

version_compare () {
    if [[ $1 == $2 ]]
    then
        return 0
    fi
    local IFS=.
    local i ver1=($1) ver2=($2)

    # fill empty fields in ver1 with zeros
    for ((i=${#ver1[@]}; i<${#ver2[@]}; i++)); do
        ver1[i]=0
    done

    for ((i=0; i<${#ver1[@]}; i++)); do
        if [[ -z ${ver2[i]} ]]
        then
            # fill empty fields in ver2 with zeros
            ver2[i]=0
        fi
        if ((10#${ver1[i]} > 10#${ver2[i]}))
        then
            return 1
        fi
        if ((10#${ver1[i]} < 10#${ver2[i]}))
        then
            return 2
        fi
    done
    return 0
}

update_arm_compiler () {
    local ARM_EABI_DOWNLOAD_LINK="$1"
    local LOGFILE="$2"
    local ARM_EABI_DOWNLOAD_FILENAME="${ARM_EABI_DOWNLOAD_LINK##*/}"

    print_message "Downloading ${ARM_EABI_DOWNLOAD_FILENAME} from the Internet."

    cd ~/
    curl -Lo ~/$ARM_EABI_DOWNLOAD_FILENAME $ARM_EABI_DOWNLOAD_LINK

    EXISTING_TOOLS=(`ls /usr/local/ | grep gcc-`)

    ARM_EABI_DIRECTORY=`tar tjf $ARM_EABI_DOWNLOAD_FILENAME | head -1 | sed -e 's/\/.*//'`
    ARM_EABI_DIRECTORY=${ARM_EABI_DIRECTORY%/}

    print_message "Unpacking the archive..."

    tar -xjvf $ARM_EABI_DOWNLOAD_FILENAME >> $LOGFILE 2>&1

    for file in "${EXISTING_TOOLS[@]}"; do
        sudo rm -rf /usr/local/${file%/}
    done

    sudo mv ~/$ARM_EABI_DIRECTORY /usr/local/$ARM_EABI_DIRECTORY
    rm $ARM_EABI_DOWNLOAD_FILENAME

    sudo rm /home/vagrant/gcc-arm-none-eabi-4_9-2015q2
    ln --symbolic /usr/local/$ARM_EABI_DIRECTORY /home/vagrant/gcc-arm-none-eabi-4_9-2015q2

    for file in "${EXISTING_TOOLS[@]}"; do
        sudo ln --symbolic /usr/local/$ARM_EABI_DIRECTORY  /usr/local/${file%/}
    done
}
