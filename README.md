# Getting-Started-with-Ansible
Installation, configuration, and execution of Ansible Playbooks with Cumulus Linux NOS setup examples
#
Readme file: Ansible Playbooks for Cumulus Linux NOS install and setup

Installation of Ansible

The general configuration and dependencies for installing Ansible and running playbooks to configure
 Cumulus on a switch are as follows.

Required systems:

    Control Server:  Linux Ubuntu system with Ansible installed (Ubuntu 16.04.04 verified)

    HTTP Server:  Server accessible via http:// URL for installation binarys and licens files

    Target switch:  Switch that is setup on a common network with the control and http servers running ONIE

    Terminal server: Generally a PC running a console terminal app such as Tera Term or Putty

Configure Ansible on Control server

    You can install ansible with:  apt-get install ansible

    Verify ansible is installed with:  ansible --version
    Configuration should look something like this:

      ansible 2.5.0
      config file = /etc/ansible/ansible.cfg
      configured module search path = [u'/root/.ansible/plugins/modules', u'/usr/share/ansible/plugins/modules']
      ansible python module location = /usr/lib/python2.7/dist-packages/ansible
      executable location = /usr/bin/ansible
      python version = 2.7.12 (default, Dec  4 2017, 14:50:18) [GCC 5.4.0 20160609]

    Note: ansible requires python to be installed as well
    Note: Ansible install documentation can be found here:
          http://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html

Create HTTP server

    HTTP server can be a stand alone web server that you can place files on or you can create a simple
    http server on your control server.  To do this execute the following in a working directory:

    mkdir /root/cumulus
    cd /root/cumulus
    python2 -m SimpleHTTPServer 80 &

    Place your Cumulus binary installation file and license file via ftp/sftp/tftp/scp/etc in the workingi
     directory.
    It should be visible by a browser on the local network at URL:

    http://[control server]/

    You should see similar files when connected to this URL with a browser:

     cumulus-linux-3.5.0-bcm-amd64.bin
     cumulus_license.txt

Switch ready state

    The target switch should be installed with the management port on the back of the switch connected
    to the local network and an IP assigned to the switch.  A console connection should also be defined
    so that switch status can be monitored.  The console terminal should have the following promt if ONIE
    is installed correctly:

    ONIE:#

    If ONIE is in discovery state it will try to look for NOS installers.  To stop this you can use the command:

    onie-dicovery-stop

Ansible setup and Playbooks

    Reguried files and execution:

      ansible.cfg  definition and configuration file - using default config file for these playbooks

      hosts  definition and configuration file - target switch and other systems defined in hosts file

      roi.cfg  variable definition file - used for dependencies in roi.sh script - in ./scripts dir

      roi.sh  execution script for ssh command - used by remote-onie-install.yml playbook - in ./scripts dir

      remote-onie-install.yml  YAML playbook executed by ansible for install on switch running ONIE only 

      cumulus-bin-install.yml  YAML playbook executed by ansible for re-installing/upgrade of cumulus NOS

      cumulus-lic-install.yml  YAML playbook executed by ansible to install cumulus license file on switch

      cumulus-dry-install.yml  YAML playbook executed by ansible to verify config and dry run install

    Directory strucure, root user,  and permissions:

      The execution directory should be a directory created in the root user directory and playbooks
      should be run as root.  For this example the execution directory is:

      /root/ansible

      The permissions and directory structure is defined as follows from your working directory:

      root@DPR-LABVM-01:~/ansible# ls -aRl
      .:
      total 80
      drwxr-xr-x  3 root root  4096 Apr 18 10:24 .
      drwx------ 13 root root  4096 Apr 18 10:23 ..
      -rw-r--r--  1 root root 19315 Apr 17 19:15 ansible.cfg
      -rw-r--r--  1 root root   985 Apr 17 19:15 cumulus-bin-install.yml
      -rw-r--r--  1 root root   689 Apr 17 19:15 cumulus-dry-install.yml
      -rw-r--r--  1 root root   467 Apr 17 19:15 cumulus-lic-install.yml
      -rw-r--r--  1 root root   431 Apr 17 19:15 hosts
      -rw-r--r--  1 root root  5520 Apr 17 19:15 Readme.md
      -rw-r--r--  1 root root 20480 Apr 18 10:39 .Readme.md.swp
      -rw-r--r--  1 root root   123 Apr 18 10:16 remote-onie-install.yml
      drwxr-xr-x  2 root root  4096 Apr 18 10:23 scripts

      ./scripts:
      total 20
      drwxr-xr-x 2 root root 4096 Apr 18 10:23 .
      drwxr-xr-x 3 root root 4096 Apr 18 10:24 ..
      -rw-r--r-- 1 root root  460 Apr 18 10:23 roi.cfg
      -rwxr-xr-x 1 root root  716 Apr 18 10:21 roi.sh
      -rwxr-xr-x 1 root root  420 Apr 17 19:15 update-host-key
      root@DPR-LABVM-01:~/ansible#



    Ansible commands to execute playbooks:

      1. Install Cumulus NOS on switch running ONIE:

           ansible-playbook remote-onie-install.yml --ask-pass

      2. Re-install/Upgrade Cumulus NOS on switch running Cumulus NOS:

           ansible-playbook cumulus-bin-install.yml --ask-pass --ask-sudo-pass

      3. Install Cumulus license file:

           ansible-playbook cumulus-lic-install.yml --ask-sudo-pass

        Note 1: sudo password for default cumulus user on cumulus NOS is: CumulusLinux!
                Use this password for SSH password on install and enter
                a return for the SUDO password and it uses same password
                for both.

        Note 2: ONIE root user password is: <none>   enter return

        Note 3: -vvv and -vvvv are sometimes useful as they extend the level of verbose
                reporting through execution

     SSH Keys

       If you have issues with authentication when running ansible playbooks you may need 
       to generate a new SSH key and copy it to the switch.  The commands to do this are:

           ssh-keygen -f "/root/.ssh/known_hosts" -R <switch IP/Name> 

           ssh-copy-id <switch user ID>@<switch IP/Name>

       There is a script in the script directory that will do this for you and is run as 
       follows:

           update-host-keys <switch IP/Name> <switch user ID>

       For a cumulus default switch credentials are:

          Login: cumulus
          Password:  CumulusLinux!

