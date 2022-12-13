#!/usr/local/bin/bash

# header
function cool_header()
                       {
        cat <<EOF


                  _     _ ______ ______
                 (_)   (_) _____|____  \  _                _
                  _     ( (____  ____)  )| |_ _____  ___ _| |_
                 | |   | \____ \|  __  (_   _) ___ |/___|_   _)
                 | |___| |____) ) |__)  )| |_| ____|___ | | |_
                  \_____(______/|______/  \__)_____|___/   \__)
  .--.      .--.     .--.      .--.      .--.      .--.      .--.      .--.
:::::.\::::::::.\::::::::.\::::::::.\::::::::.\::::::::.\[ 0.0.1 ]\::::::::.\::
        --        --        --        --        --        --        --

EOF
}

cool_header

function step_one()
                    {

        echo -e "\nFind the Bus and Device ID.\nCommand 'lsusb' will provide that info. Something like:\n"

        cat <<EOF
...
Bus 001 Device 008: ID 0781:5151 SanDisk Corp. Cruzer Micro Flash Drive
...

EOF

        echo -e "\n ------------------- ---------------------------------- ---------------- \n\n"
        lsusb
        echo
}

step_one

function step_two()
                    {
        read -p "Enter the USB Drive Bus ID: : " busID
        read -p "Enter the USB Drive Device Address: : " hostAddy

        echo -e "\nPreparing to run the following command:\n\nsudo qemu-system-x86_64 -m 512 -enable-kvm -usb -device usb-host,hostbus=${busID},hostaddr=${hostAddy}\n"

        sudo qemu-system-x86_64 -m 512 -enable-kvm -usb -device usb-host,hostbus="${busID}",hostaddr="${hostAddy}"
}

step_two
