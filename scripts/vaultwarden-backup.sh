#!/bin/bash
set -e

SERVICE="vaultwarden_vaultwarden"
DATA_DIR="/mnt/vaultwarden/data"
WORK_DIR="/mnt/backup-er"
NAS_MOUNTPOINT="/mnt/nas_Install"
NAS_DIR="/mnt/nas_Install/vaultwarden/backups"

DATE=$(date +"%Y%m%d_%H%M")
HOSTNAME=$(hostname)
FILENAME="${DATE}_vaultwardenData_${HOSTNAME}.zip"
TMP_FILE="${WORK_DIR}/${FILENAME}"

echo "=== Backup started at $(date) ==="

if ! mountpoint -q ${NAS_MOUNTPOINT}; then
    echo "NAS not mounted. Aborting."
    exit 1
fi

echo "Scaling ${SERVICE} to 0..."
docker service scale ${SERVICE}=0

echo "Waiting for service shutdown..."
while docker service ps ${SERVICE} --filter "desired-state=running" --format "{{.ID}}" | grep -q .; do
    sleep 10
done

echo "Creating archive..."
cd /mnt/vaultwarden
zip -r "${TMP_FILE}" data

echo "Copying to NAS..."
cp "${TMP_FILE}" "${NAS_DIR}/"

if [ -f "${NAS_DIR}/${FILENAME}" ]; then
    echo "Backup copied successfully."
    rm "${TMP_FILE}"
else
    echo "Backup copy failed!"
    exit 1
fi

echo "Scaling ${SERVICE} back to 1..."
docker service scale ${SERVICE}=1

echo "=== Backup completed at $(date) ==="

