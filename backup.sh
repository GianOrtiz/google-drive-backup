#!/bin/bash

# This script receives a list of parameters, name of files, to backup to Google
# Drive. You can use it with a cronjob to setup it daily, weekly, etc. It uses
# drive command line tool to upload the files to drive.

# Parse files and no prompt flag in command arguments.
FILES=()
NO_PROMPT=false
while (( $# > 0 )); do
    case "$1" in
        --no-prompt )
            NO_PROMPT=true
            ;;
        * )
            FILES+=("$1")
        ;;
    esac
    shift
done

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

drive init --service-account-file $SERVICE_ACCOUNT_FILE ~/.gdrive

cd ~/.gdrive
# Create new directory for the backup.
FORMATTED_DATE=$(date +"%Y-%m-%d-%H-%M-%S")
BACKUP_DIR="backup_$FORMATTED_DATE"
mkdir $BACKUP_DIR

# Copy files and directories to the backup directory.
for FILE in "${FILES[@]}"
do
    if [[ -d $FILE ]]; then
        # If it is a directory make a copy of every file inside it to a
        # directory with same name on the backup directory.
        cp -d -r $FILE $BACKUP_DIR
    elif [[ -f $FILE ]]; then
        # If it is a file copy the file to the backup directory.
        cp $FILE $BACKUP_DIR
    else
        echo "file $FILE is not valid"
        exit 1
    fi
done

# Push backup directory to google drive.
if $NO_PROMPT; then
    drive push --no-prompt $BACKUP_DIR
else
    drive push $BACKUP_DIR
fi
