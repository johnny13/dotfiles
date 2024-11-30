# add this to /etc/fstab
huement@openmediavault.local:/srv/dev-disk-by-uuid-7574ae65-8e7c-4115-914c-dbf36953dd24/Vault /home/derek/Vault fuse.sshfs defaults,rw,nosuid,nodev,relatime,user_id=0,group_id=0 0 0


# This Works For the VM
huement@openmediavault.local:/srv/dev-disk-by-uuid-7574ae65-8e7c-4115-914c-dbf36953dd24/Vault /home/derek/Vault fuse.sshfs noauto,x-systemd.automount,_netdev,reconnect,identityfile=/home/derek/.ssh/id_rsa,allow_other,default_permissions 0 0

# NOTE: dev-disk-by-uuid comes from OMV and never changes. 


# defaults,_netdev,allow_other 0 0

sudo sshfs -o allow_other,default_permissions

sudo sshfs -o allow_other,default_permissions huement@openmediavault.local:/srv/dev-disk-by-uuid-7574ae65-8e7c-4115-914c-dbf36953dd24/Vault /home/derek/Vault
