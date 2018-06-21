************************************************************************
1. createImagesBasedOnTags.py  

This script creates the backup of those instances which are marked with the tag “AutomaticBackup” with value “True” {“AutomaticBackup”:”True”}.

2. deleteBackupsBasedOnTags-backupManager.py 

It reads the instance tag RetentionCount (in days) and deletes the older images. If no tag is specified by default it retains the backups of last 30 days and deletes the older images.
