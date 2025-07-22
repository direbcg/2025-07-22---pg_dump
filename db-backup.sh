#!/bin/bash

MAX_BACKUPS=7
BACKUP_FOLDER="/opt/backups/"
LOG_FILE="/var/log/db-backup.log"
BACKUP_TIME=$(date +"%Y-%m-%d_%H-%M")
set -o pipefail
source /opt/db.env
export PGPASSWORD=$DB_PASSWORD

mkdir $BACKUP_FOLDER -p
pg_dump -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME | gzip > $BACKUP_FOLDER/$DB_NAME_$BACKUP_TIME.sql.gz && echo "$BACKUP_TIME: Дамп БД $DB_NAME выполнен. Размер: $(du -h $BACKUP_FOLDER/$DB_NAME_$BACKUP_TIME.sql.gz | awk '{print $1}')" >> $LOG_FILE || ( echo "$BACKUP_TIME: Ошибка дампа БД $DB_NAME" >> $LOG_FILE ; rm $BACKUP_FOLDER/$DB_NAME_$BACKUP_TIME.sql.gz )
