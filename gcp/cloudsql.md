# Cloud SQL

By default, backups are set to run once per day with a 7 day retention period.

Backups may be restored to the active instance.

[Point in time recovery](https://cloud.google.com/sql/docs/mysql/backup-recovery/backups#usingpitr) is also 
available with binary logs enabled. This minimally impacts writes, but not reads.

## Manage databases and users

```bash
# List databases
gcloud sql databases list --instance=[INSTANCE_NAME]

# Delete database
gcloud sql databases delete [DATABASE_NAME] --instance=[INSTANCE_NAME]

# Configure default user
gcloud sql users set-password root \
   --host=% --instance=[INSTANCE_NAME] --prompt-for-password

# Create a user
gcloud sql users create [USER_NAME] \
   --host=[HOST] --instance=[INSTANCE_NAME] --password=[PASSWORD]

# Change a password
gcloud sql users set-password [USER_NAME] \
   --host=[HOST] --instance=[INSTANCE_NAME] --prompt-for-password

# List users
gcloud sql users list --instance=[INSTANCE_NAME]

# Delete users
gcloud sql users delete [USER_NAME] --host=[HOST] --instance=[INSTANCE_NAME]
```



## Restore

Restoring a backup restores an image of the entire system. If you wish to export/import individual
databases, see the next section.

```bash
# List replicas
gcloud sql instances describe [INSTANCE_NAME]

# Delete replicas
gcloud sql instances delete [REPLICA_NAME]

# List backups
gcloud sql backups list --instance

# Restore
gcloud sql backups restore [BACKUP_ID] --restore-instance=[INSTANCE_NAME]
```

## Import/Export Databases
https://cloud.google.com/sql/docs/mysql/import-export/exporting
```bash
# Create a bucket
gsutil mb -p [PROJECT_NAME] -l [LOCATION_NAME] gs://[BUCKET_NAME]

# Export a database
gcloud sql export sql [INSTANCE_NAME] gs://[BUCKET_NAME]/sqldumpfile.gz \
 --database=[DATABASE_NAME]

# Export a query to CSV
gcloud sql export csv [INSTANCE_NAME] gs://[BUCKET_NAME]/[FILE_NAME] \
 --database=[DATABASE_NAME] --query=[SELECT_QUERY]

# Export from a local server
mysql --host=[INSTANCE_IP] --user=[USER_NAME] --password [DATABASE] \
-e " SELECT * FROM [TABLE] INTO OUTFILE '[FILE_NAME]' CHARACTER SET 'utf8mb4'
     FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"' ESCAPED BY '\"' "


# Import
gcloud sql import sql [INSTANCE_NAME] gs://[BUCKET_NAME]/[IMPORT_FILE_NAME] \
 --database=[DATABASE_NAME]

# Import from CSV
gcloud sql import csv [INSTANCE_NAME] gs://[BUCKET_NAME]/[FILE_NAME] \
 --database=[DATABASE_NAME] --table=[TABLE_NAME]
```

## Reference

- [Manage Databases and Users](https://cloud.google.com/sql/docs/mysql/create-manage-databases#gcloud_1)
- [Cloud SQL Restore](https://cloud.google.com/sql/docs/mysql/backup-recovery/restoring#gcloud)
- [Point in Time Recovery](https://cloud.google.com/sql/docs/mysql/backup-recovery/backups#usingpitr)
