#!/bin/bash

# This checks if the number of arguments is correct
# If the number of arguments is incorrect ( $# != 2) print error message and exit
if [[ $# != 2 ]]
then
  echo "backup.sh target_directory_name destination_directory_name"
  exit
fi

# This checks if argument 1 and argument 2 are valid directory paths
if [[ ! -d $1 ]] || [[ ! -d $2 ]]
then
  echo "Invalid directory path provided"
  exit
fi

targetDirectory=$1
destinationDirectory=$2

echo "Target directory: $targetDirectory"
echo "Destination directory: $destinationDirectory"

currentTS=`date +%s`

backupFileName="backup-$currentTS.tar.gz"

# We're going to:
  # 1: Go into the target directory
  # 2: Create the backup file
  # 3: Move the backup file to the destination directory

origAbsPath=`pwd`

cd $destinationDirectory
destDirAbsPath=`pwd`

cd $origAbsPath
cd $targetDirectory

yesterdayTS=$(($currentTS-60*60*24))

declare -a toBackup

for file in $(ls) 
do
  if (( `date -r $file +%s` > $yesterdayTS ))
  then
    toBackup+=($file)
  fi
done

tar -czvf $backupFileName ${toBackup[@]}
mv $backupFileName $destDirAbsPath

#after that i scheduled this script using '0 0 * * * /path/to/backup.sh arg1 arg2' command in the 'crontab -e', to backup arg1 every 24 hours to arg2