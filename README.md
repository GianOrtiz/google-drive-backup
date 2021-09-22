# Google Drive Backup Script

A bash script to make a cheap backup of files using Google Drive as storage.

## How to use

To make a backup to Google Drive we need a service account key to allow access to Google Drive. To create one, we need to enable Google Drive API on [Google Cloud](https://console.cloud.google.com/apis/library/drive.googleapis.com), create a [service account](https://console.cloud.google.com/iam-admin/serviceaccounts/create), and create a new JSON key for the service account downloading it.

Make sure you have [Go](https://golang.org/doc/install) installed.

Currently, we must supply the service account key file as an environment variable, `SERVICE_ACCOUNT_FILE`, to make a backup of a file at `~/file.json` and a directory at `~/dir` we can use the following command:

```
SERVICE_ACCOUNT_FILE=service-account-key.json ./backup.sh ~/file.json ~/dir
```

The command will create a copy of `file.json` and all the files and directories in `dir` at `~/.gdrive/backup_DATE-HOUR` and upload it to Google Drive as a folder named `backup_DATE-HOUR`.
