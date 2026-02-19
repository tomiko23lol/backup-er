# backup-er

`backup-er` is a lightweight containerized backup utility designed to run inside a Docker Swarm environment and perform **automated, scheduled backups of application data** (currently focused on Vaultwarden, but can be used basically for any cron job that can be run from container and controlled by docker).

The project is intentionally simple, transparent, and reproducible, making it suitable for personal infrastructure while remaining safe to publish publicly. 

---

## What backup-er Is Intended For

`backup-er` is intended for:

- Periodic backups of self-hosted services
- Running as a **Docker service** specially benefitial in **swarm**  where you try to achieve some level of reseliency
- Storing backups on **external SMB/CIFS storage**
- Fully automated operation via cron
- Minimal dependencies and easy deployment and recovery

It is **not** a general backup framework — it is purpose-built and opinionated for me and my environment.

---

## My setting / my environment 

- docker swarm running on 3 VMs ( dockernode1, dockernode2, dockernode3
- dockernode1 and 2 are managers and workers at the same time
- dockernode3 is manager only ( to get quorum)
- each node is running GlusterFS so that container can be deployed anywhere in cluster and it will have its files there.
- all 3 nodes have Virtual IPs configured (VRRP)
- cluster is managed by portainer

---

## What backup-er Achieves

- Runs scheduled backups inside a container
- Executes a Vaultwarden-specific backup script
- Writes backups to a mounted SMB share
- Keeps backup logic isolated from the host, so even when dockernode1 is down, it will automaticaly be deployed on node2 and run job.
- Works across Swarm nodes (assuming shared / copyed storage by GlusterFS)

---

## Prerequisites

### Infrastructure Requirements

- Linux hosts ( ubuntu )
- Docker installed
- Docker Swarm initialized and running
- Portainer installed and working
- Shared storage accessible from all Swarm nodes ( glusterFS ) 
- SMB/CIFS share is mounted on each dockernode

### Docker Swarm

This project assumes:

- A multi-node Docker Swarm cluster
- Swarm services are used instead of standalone containers
- Volumes and mounts are consistently available on all nodes

---

## Installing Host Prerequisites

### Install CIFS / SMB Support

do this on each dockernode

```bash
sudo apt update
sudo apt install -y cifs-utils

sudo mkdir -p /mnt/nas_Install

```

### Make SMB mount persistent

edit /etc/fstab on each dockernode

```bash
#mount NAS_install_folder
//192.168.23.3/nas/Install /mnt/nas_Install cifs username=SMBUSERNAME,password=SMBPASSWORD,iocharset=utf8,_netdev 0 0

```


## backup-er deployment

### Create all needed folders

```bash
#mount NAS_install_folder
//192.168.23.3/nas/Install /mnt/nas_Install cifs username=SMBUSERNAME,password=SMBPASSWORD,iocharset=utf8,_netdev 0 0

```




