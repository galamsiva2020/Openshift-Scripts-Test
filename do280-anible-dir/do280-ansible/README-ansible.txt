This Ansible Playbook is not designed to correct any type of mistake that you
may have made. The following commands will work from /home/student on
workstation if you have reset both the master, node1 and node2 hosts. The following
commands *may* work even if you haven't reset the master and node hosts.

Some additional troubleshooting tips are listed below.

For the end state of "Guided Exercise: Preparing for Installation"
$ ansible-playbook prepare_install.yml

For the end state of "Guided Exercise: Running the Installer"
NOTE: This will *not* correct an incorrectly installed OCP installation.
$ ansible-playbook install_ocp.yml

For the end state of "Guided Exercise: Completing Postinstallation Tasks"
NOTE: This playbook requires a working installation of OCP.
$ ansible-playbook post_install.yml

To run all the above playbooks, run the playbook without any tags.
$ ansible-playbook full_classroom_install.yml

================================================================================
Additional Troubleshooting Tips
================================================================================
1. Problems with docker-storage-setup
================================================================================
If you are having problems with docker-storage-setup (possibly because you
manually typed /etc/sysconfig/docker-storage-setup and made a mistake or
maybe you started the docker service prior to running docker-storage-setup),
try the following:

# systemctl stop docker (stop the docker service)
# rm -rf /var/lib/docker/* (remove any files previously created by docker)
# vgremove docker-vg (remove the docker-vg volume group if it exists)
# pvremove /dev/vdb1 (make sure /dev/vdb1 isn't considered a physical volume)
# fdisk /dev/vdb (remove /dev/vdb1 with "d" and then save your changes with "w")
# partprobe /dev/vdb (make sure the kernel is aware of the partition changes)

Add the line (WIPE_SIGNATURES=true) to /etc/sysconfig/docker-storage-setup
so that the file has the following contents:
DEVS=/dev/vdb
VG=docker-vg
SETUP_LVM_THIN_POOL=yes
WIPE_SIGNATURES=true

# docker-storage-setup (try running docker-storage-setup again)

If the docker-storage-setup command completes successfully, go back and modify
/etc/sysconfig/docker-storage-setup to remove the "WIPE_SIGNATURES=true" line
from the file. This will ensure that it doesn't cause additional problems with
the Ansible Playbook.

================================================================================
2. Problems with OpenShift Container Platform Installation
================================================================================
Using these Ansible Playbooks will not fix or correct a bad installation. To
resolve this reset both the master and node hosts and then try running the
Ansible full_classroom_install.yml playbook again.
================================================================================
