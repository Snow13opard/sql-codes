#!/bin/sh
read -p "Please enter your mysql username  : " username
read -p "Please enter your mysql password  : " password
read -p "Please enter your database name  : " mydatabase
RESULT=`mysqlshow --user=$username --password=$password $mydatabase | grep -o $mydatabase`
if [ "$RESULT" == "$mydatabase" ]; then

  now="$(date +'%d_%m_%Y_%H_%M_%S')"
  filename="db_backup_$now".gz
  backupfolder="/var/mysql-backups"
  fullpathbackupfile="$backupfolder/$filename"
  logfile="$backupfolder/"backup_log_"$(date +'%Y_%m')".txt

  echo "mysqldump started at $(date +'%d-%m-%Y %H:%M:%S')" >> "$logfile"
  mysqldump --user=$username --password=$password --default-character-set=utf8 $mydatabase | gzip > "$fullpathbackupfile"
  echo "mysqldump finished at $(date +'%d-%m-%Y %H:%M:%S')" >> "$logfile"

  find "$backupfolder" -name db_backup_* -mtime +8 -exec rm {} \;
  echo "old files deleted" >> "$logfile"

  echo "operation finished at $(date +'%d-%m-%Y %H:%M:%S')" >> "$logfile"
  echo "*****************" >> "$logfile"
  echo "Created backup for $filename in /var/mysql-backups"
  exit 0
else
  echo "Database not found."
fi
