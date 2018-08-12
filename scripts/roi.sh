#!/bin/bash

#  Copyright (C) 2018 Ron Wilhelmson <ron.wilhelmson@deltaww.com>
#
#  

##
## remote-onie-install 
##
## History: 12APR2018 Ron.Wilhelmson Initial Creation
##          04MAY2018 Ron.Wilhelmson Update for NOS install options cumulus or icos
##          25MAY2018 Ron.Wilhelmson Update for NOS install option ocnos
##          06JUL2018 Ron.Wilhelmson Update for NOS install option onl 
#
# Dependencies: roi.cfg in same directory

# Set environment variables from roi.cfg for switch and server names/IPs
source /root/ansible/scripts/roi.cfg

echo ""
echo "Target switch set to: $target_switch"
echo ""
echo "HTTP server set to: $http_server"
echo ""
echo "NOS to be installed on Target switch: $NOS_install"

echo "Sending install command to switch"


case $NOS_install in 
   cumulus) /usr/bin/ssh -a -l root $target_switch /bin/onie-nos-install http://"$http_server"/cumulus-linux-3.5.0-bcm-amd64.bin
      echo ""
      ;; 

   icos) /usr/bin/ssh -a -l root $target_switch /bin/onie-nos-install http://"$http_server"/onie-icos-installer-x86_64-ag7648
      echo ""
      ;; 

   ocnos) /usr/bin/ssh -a -l root $target_switch /bin/onie-nos-install http://"$http_server"/DELTA_AGC7648A-OcNOS-1.3.2.137-DC_MPLS_ZEBM-S0-P0-installer
      echo ""
      ;;

   onl) { 
        sleep 10
        echo /bin/install_url http://"$http_server"/AG9032v1/ONL-2.0.0_ONL-OS_2018-01-17.0840-6f80df8_AMD64_INSTALLED_INSTALLER
        sleep 60
        echo exit
        } | telnet $target_switch

esac 

echo "Waiting for onie to download and install"

sleep 60

echo "Rebooting switch"

#/usr/bin/ssh -l root $target_switch /sbin/reboot

