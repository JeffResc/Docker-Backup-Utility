# Docker-Backup-Utility
[![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/jeffresc/docker-backup-utility?style=for-the-badge)](https://hub.docker.com/repository/docker/jeffresc/docker-backup-utility) [![GitHub last commit](https://img.shields.io/github/last-commit/JeffResc/Docker-Backup-Utility?style=for-the-badge)](https://github.com/JeffResc/Docker-Backup-Utility)

A custom Docker backup utility to backup Docker containers using [rclone](https://rclone.org/).

# What It Does
Simple backup utility that backs up a Docker container to anything that [rclone supports](https://rclone.org/docs/).

# Example
## Assumptions
For this example I will assume the following things:
- `~/Docker-Backup-Utility/rclone` contains your `rclone.conf` file. If your file resides elsewhere, change this in the `docker run` command below.
- `~/Docker-Backup-Utility/backup.json` is the path to your `backup.json` file. If your file resides elsewhere, change this in the `docker run` command below.
- `/var/docker-data` is the location of your stored Docker data that you wish to backup. If your files reside elsewhere, change this in the `docker run` command below.
## The Command
Use the following command as a template for your backup, ensuring to modify it to your needs following the assumtions guide above.
```bash
docker run --rm \
           -v ~/Docker-Backup-Utility/rclone:/root/.config/rclone \
           -v ~/Docker-Backup-Utility/backup.json:/root/backup.json:ro \
           -v /var/docker-data:/docker-data:ro \
           -v /var/run/docker.sock:/var/run/docker.sock:ro \
           jeffresc/docker-backup-utility:latest
```
