#!/usr/bin/env bash

echo 'Mounting OpenMediaVault via SSHFS'
echo 'Running sshfs command'

sshfs huement@openmediavault.local:/srv/dev-disk-by-uuid-7574ae65-8e7c-4115-914c-dbf36953dd24/Vault /home/derek/Vault

echo ''
echo '/home/derek/Vault should now contain OMV data'
echo 'Running "cat /etc/mtab" should also contain an entry for OMV'
echo ''
