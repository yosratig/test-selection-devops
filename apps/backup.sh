#!/bin/bash

DB_CONTAINER="apps-db-1"
DB_USER="odoo"
DB_NAME="odoo"
ODOO_CONTAINER="apps-odoo-1"
FILESTORE_PATH="/var/lib/odoo/filestore"
BACKUP_DIR="/backup"
LOG_FILE="/var/log/backup.log"

DATE=$(date +%Y%m%d_%H%M%S)

echo "$(date) - Début du backup" >> "$LOG_FILE"

docker exec "$DB_CONTAINER" pg_dump -U "$DB_USER" "$DB_NAME" > "$BACKUP_DIR/db_$DATE.sql"
echo "$(date) - Base de données sauvegardée : db_$DATE.sql" >> "$LOG_FILE"

docker exec "$ODOO_CONTAINER" tar -czf - "$FILESTORE_PATH" > "$BACKUP_DIR/filestore_$DATE.tar.gz"
echo "$(date) - Filestore sauvegardé : filestore_$DATE.tar.gz" >> "$LOG_FILE"

tar -czf "$BACKUP_DIR/backup_$DATE.tar.gz" -C "$BACKUP_DIR" "db_$DATE.sql" "filestore_$DATE.tar.gz"
echo "$(date) - Archive finale créée : backup_$DATE.tar.gz" >> "$LOG_FILE"

rm "$BACKUP_DIR/db_$DATE.sql" "$BACKUP_DIR/filestore_$DATE.tar.gz"

echo "$(date) - Backup terminé avec succès" >> "$LOG_FILE"
