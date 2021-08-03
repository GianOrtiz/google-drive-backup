#!/bin/bash

# This script receives a list of parameters, name of files, to backup to Google Drive. You can use it with a
# cronjob to setup it daily, weekly, etc. It uses drive command line tool to upload the files to drive.

# Ensures drive command line tool is installed.
if ! command -v drive &> /dev/null; then
    echo "drive is not installed, installing it..."
    # Ensures go is installed before installing drive using it.
    if ! command -v go &> /dev/null; then
        echo "go is not installed, please visit https://golang.org/doc/install to install it"
        echo "aborting..."
        exit 1
    fi
    # Install drive command line tool from the latest release in github.
    go get -u github.com/odeke-em/drive/cmd/drive
fi

drive init ~/.gdrive

cd ~/.gdrive
# Create new directory for the backup.
FORMATTED_DATE=$(date +"%Y-%m-%d-%H-%M-%S")
BACKUP_DIR="backup_$FORMATTED_DATE"
echo $BACKUP_DIR
mkdir $BACKUP_DIR

# Parses arguments and locate files to backup and copy them to backup directory.
for FILE in "$@"
do
    cp $FILE $BACKUP_DIR
done

# Push backup directory to google drive.
drive push $BACKUP_DIR
