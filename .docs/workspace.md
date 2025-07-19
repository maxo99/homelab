
# Swag
https://github.com/linuxserver/docker-swag



# BTRFS
- [BTRFS maintainence scripts](https://github.com/kdave/btrfsmaintenance)
- [BTRFS encrypted drive guide](https://gist.github.com/MaxXor/ba1665f47d56c24018a943bb114640d7)
- [BTRFS Use Cases](https://btrfs.wiki.kernel.org/index.php/UseCases)


root@pve:~# btrfs filesystem show
Label: 'proxmox-storage'  uuid: c7f484df-3441-4b44-9409-110fcd75958e
	Total devices 1 FS bytes used 3.19TiB
	devid    2 size 20.01TiB used 3.20TiB path /dev/sdb


root@pve:~# btrfs fi df /mnt/btrfs-storage
Data, single: total=3.19TiB, used=3.18TiB
System, DUP: total=32.00MiB, used=384.00KiB
Metadata, DUP: total=4.00GiB, used=3.38GiB
GlobalReserve, single: total=512.00MiB, used=0.00B



# Setting VirtFS Options for VM usage of BTRFS storage
```
# Stop the VM first
qm stop 103

# Add shared directory using 9p filesystem
qm set 103 -virtfs local,mp=/shared,path=/mnt/shared,readonly=0

# Start the VM
qm start 103
```



`qm set 103 -virtio1 /mnt/shared,format=raw`
- backup=0                # Exclude from Proxmox backups (data stored on host)

1. Verify Current filesystem
```
btrfs filesystem show LABEL=proxmox-storage
btrfs filesystem usage /mnt/btrfs-storage
btrfs device stats /mnt/btrfs-storage
```
```
root@pve:/# btrfs filesystem show proxmox-storage
Label: 'proxmox-storage'  uuid: c7f484df-3441-4b44-9409-110fcd75958e
        Total devices 3 FS bytes used 3.19TiB
        devid    1 size 7.28TiB used 3.23TiB path /dev/sdc
        devid    2 size 20.01TiB used 0.00B path /dev/sdb
        devid    3 size 7.28TiB used 0.00B path /dev/sdd
```

3. Start the balance operation to move data from /dev/sdc to /dev/sdb:
```
btrfs balance start -ddevid=2 /mnt/btrfs-storage



btrfs filesystem balance start -dconvert=single -mconvert=single /mnt/btrfs-storage

btrfs filesystem balance status /mnt/btrfs-storage

- Subvolumes: @personal, @shared, @snapshots
- **Mount point**: /mnt/btrfs-storage

- **Hardware**: Proxmox VE 8+ on dedicated OS drive
- **Storage**: 2x 8TB drives + 1x 23TB drive (39TB total raw capacity)