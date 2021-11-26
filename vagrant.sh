#!/usr/bin/bash

# function vrun(){
    
# }

function vcreate(){
    VMNAME=$1
    VMFOLDER=$2
    VMSUBFOLDER=$3
    VagrantBOX=$4
    VMWORKDIR=/Users/naimulhasan/Developer/vagrant-vms/
    DIRECTORY=$VMWORKDIR$VMFOLDER/$VMSUBFOLDER

    if [ "$#" -ne 4 ]; then
        echo "You must enter exactly 4 command line arguments"
        echo "vcreate [vm name] [vm folder] [vm subfolder] [vagrant init command]"
        echo "Example: vcreate ubuntu20 Ubuntu 20.04 bento/ubuntu-20.04"
        (exit 1)
        return
    fi

    if [ ! -d "$DIRECTORY" ]; then
        echo "Directory $DIRECTORY was not found. Would you like to create it? [y/n] default y:"
        echo -e "\e[31mLeave Blank for yes other wise no\e[0m"

        read ANS
        if [ -z "$ANS" ]; then
            mkdir -p $DIRECTORY
            echo -e "\e[42mDirectory created successfully\e[0m"
        else
            return 
        fi
        
        echo Initializing $VagrantBOX
        (cd DIRECTORY;vagrant init $VagrantBOX)

        if [ -f `$Directory/Vagrantfile`]; then
            # echo -e "\e[42mVagrantfile created\e[0m"
        fi
    else
        echo Initializing $VagrantBOX
        (cd $DIRECTORY; vagrant init $VagrantBOX)
        
        if [ -f `$Directory/Vagrantfile`]; then
            echo -e "\e[42mVagrantfile created\e[0m"
        fi
    fi

    echo Setting VM Name

#     sed -e "/config.vm.box =/a\\
#    config.vm.define : urname" < text.txt

    vim -c "16 s/^/  config.vm.define :$VMNAME do |t| end/" -c "wq" $DIRECTORY/Vagrantfile

    echo Done! 
    echo Turning on $VMNAME

    # echo creating vm named: $VMNAME
}

function vmup(){
    if [ "$#" -ne 1 ]; then
        echo "You must enter exactly 1 command line arguments"
        echo "vmup [vm name] [vm folder] [vm subfolder] [vagrant init command]"
        echo "Example: vcreate ubuntu20 Ubuntu 20.04 bento/ubuntu-20.04"
        (exit 1)
        return
    fi
}

