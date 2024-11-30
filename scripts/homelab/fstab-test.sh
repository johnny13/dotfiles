ssh 'huement@openmediavault.local'
openmediavault.loc
,reconnect 

defaults,rw,nosuid,nodev,relatime,user_id=0,group_id=0

defaults,reconnect,_netdev 

noauto,x-systemd.automount,_netdev,reconnect,identityfile=/home/sammy/.ssh/id_rsa,allow_other,default_permissions

rw,noauto,x-systemd.automount,_netdev,reconnect,identityfile=/home/sammy/.ssh/id_rsa,allow_other,default_permissions


noauto,x-systemd.automount,_netdev,reconnect,identityfile=/home/sammy/.ssh/id_rsa,allow_other,default_permissions



huement@openmediavault.local:/srv/dev-disk-by-uuid-7574ae65-8e7c-4115-914c-dbf36953dd24/Vault /home/derek/Vault fuse.sshfs noauto,x-systemd.automount,_netdev,reconnect,identityfile=/home/derek/.ssh/id_rsa,allow_other 0 0


huement@openmediavault.local:/srv/dev-disk-by-uuid-7574ae65-8e7c-4115-914c-dbf36953dd24/Vault /home/derek/Vault fuse.sshfs rw,noauto,x-systemd.automount,_netdev,reconnect,identityfile=/home/derek/.ssh/id_rsa,allow_other,default_permissions 0 0