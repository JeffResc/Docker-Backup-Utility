#!/bin/sh

for backup in $(jq -c '.[]' /root/backup.json); do
    # Config variables
    name=$(echo $backup | jq -r '.name')
    src_dir=$(echo $backup | jq -r '.src_dir')
    dst_dir=$(echo $backup | jq -r '.dst_dir')
    stop=$(echo $backup | jq -r '.stop')
    daysToKeep=$(echo $backup | jq -r '.daysToKeep')
    password=$(echo $backup | jq -r '.password')

    # Extra variables
    nowDate=$(date +'%F')
    fullName=${name}-${nowDate}

    # Stop containers
    if [ "$stop" = true ] ; then
        for container in $(echo $backup | jq -r -c '.containers[]'); do
            echo "Stopping ${container}..."
            docker stop ${container}
        done
    fi

    # Create temporary directory
    echo "Creating /tmp/${fullName}"
    mkdir /tmp/${fullName}

    # Move contents
    echo "Copying contents of ${src_dir} to /tmp/${fullName}"
    cp -a "${src_dir}" "/tmp/${fullName}"

    # Start containers
    if [ "$stop" = true ] ; then
        for container in $(echo $backup | jq -r -c '.containers[]'); do
            echo "Starting ${container}..."
            docker start ${container}
        done
    fi

    # Create zip
    echo "Creating /tmp/${fullName}.zip"
    cd /tmp/${fullName}
    zip -p ${password} -r "/tmp/${fullName}.zip" .

    # Upload zip
    echo "Uploading /tmp/${fullName}.zip"
    rclone move "/tmp/${fullName}.zip" "${dst_dir}"

    # Remove extra files
    rm -rf /tmp/${fullName}

    # Remove old backups
    if [ "$daysToKeep" != 0 ] ; then
        oldDate=$(date --date="${daysToKeep} days ago" +'%F')
        echo "Deleting ${dst_dir}${name}-${oldDate}.zip"
        rclone deletefile "${dst_dir}${name}-${oldDate}.zip"
    fi
done