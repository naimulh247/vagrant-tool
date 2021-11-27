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

    if [ ! -f `$DIRECTORY/Vagrantfile`]; then
        echo "another vm exists in this path"
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

        (cd $DIRECTORY; vagrant init $VagrantBOX)
        wait

        if [ -f `$Directory/Vagrantfile`]; then
            echo -e "\e[42mVagrantfile created\e[0m"
        else
            echo -e "\e[31mSomething might be wrong....\e[0m"
        fi
    
    else
        echo Initializing $VMNAME
        (cd $DIRECTORY; vagrant init $VagrantBOX)
        wait

        if [ -f `$Directory/Vagrantfile`]; then
            echo -e "\e[42mVagrantfile created\e[0m"
        else
            echo -e "\e[31mSomething might be wrong....\e[0m"
        fi
    fi

    echo Setting VM Name


    wait

    vim -c "16 s/^/  config.vm.define :$VMNAME do |t| end/" -c "wq" $DIRECTORY/Vagrantfile

    echo Done! 
    echo "Turning on $VMNAME to set name"

    (cd $DIRECTORY; vagrant up)
    wait # wait for the previous command to finish, can take a min
    
    if [ $? -eq 0 ]; then
        echo "$VMNAME is up and running 🥳"
    fi
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

function vmd(){
    if [ "$#" -ne 1 ]; then
        echo "You must enter exactly 1 command line arguments"
        (exit 1)
        return
    fi

    VMNAME=$1    
    VAGRANTGS=$(vagrant global-status)
    # VAGRANTGREP=$( vagrant global-status | grep $VMNAME | awk '{print $1; exit}')
    VAGRANTGREP=$(vagrant global-status | grep $VMNAME | awk -v vmname="$VMNAME" '$2 vmname {print $1; exit}')

    echo "Removing the first instance of $VMNAME"
    echo -e "\e[31mLeave Blank for yes otherwise press for no\e[0m"
    echo $VAGRANTGREP
    # read ANS

    if [ -z "$ANS" ]; then
        vagrant destroy $VAGRANTGREP
    else
        echo -e "\e[31mCancelled...\e[0m"
        (exit 1)
        return
    fi

    if [ ! $? -eq 0 ]; then 
        echo Something went wrong... 😞
        return
    fi

    echo "Remove directory?"
    echo -e "\e[31mLeave Blank for yes otherwise press for no\e[0m"

    read ANS
    if [ -z "$ANS" ]; then
        rm -rf $($VAGRANTGREP | grep $VMNAME | awk -v vmname="$VMNAME" '$2 vmname {print $NF; exit}')
    else
        echo -e "\e[31mCancelled...\e[0m"
        (exit 1)
        return
    fi
}

function vmshow(){
    vagrant global-status 
}

