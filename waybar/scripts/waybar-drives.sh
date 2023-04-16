#!/bin/bash

oldifs="$IFS";
IFS=$'\n';
disks=($(lsblk -o KNAME,PTTYPE,FSTYPE,LABEL,FSAVAIL,FSUSE%,MOUNTPOINT -nf));
IFS="$oldifs";

main_text='';
tooltip_text='';

for (( i=1; i<${#disks[@]}; i++ ));
do
    disk_info=(${disks[i]});
    if [ ${#disk_info[@]} == 2 ]
    then
        continue;
    fi

    disk_info_name=0;
    disk_info_pttype=1;
    disk_info_fstype=2;
    disk_info_label=3;
    disk_info_avail=4;
    disk_info_fuse=5;
    disk_info_path=6;

    if [ ${#disk_info[@]} -ge 3 -a ${#disk_info[@]} -le 4 ]
    then
        tooltip_text="$tooltip_text${disk_info[disk_info_name]}\t${disk_info[disk_info_pttype]}\t${disk_info[disk_info_fstype]}\t${disk_info[disk_info_label]}\n";
    elif [ ${#disk_info[@]} == 6 ]
    then
        tooltip_text="$tooltip_text${disk_info[disk_info_name]}\t${disk_info[disk_info_pttype]}\t${disk_info[disk_info_fstype]}\t\t${disk_info[3]}\t${disk_info[4]}\t${disk_info[5]}\n";

        if [[ ${disk_info[6]} == "/" ]]
        then
            main_text=" ${disk_info[5]} ${disk_info[3]} ${disk_info[4]}";
        fi
    else
        tooltip_text="$tooltip_text${disk_info[disk_info_name]}\t${disk_info[disk_info_pttype]}\t${disk_info[disk_info_fstype]}\t${disk_info[disk_info_label]}\t${disk_info[disk_info_avail]}\t${disk_info[disk_info_fuse]}\t${disk_info[disk_info_path]}\n";

        if [[ ${disk_info[disk_info_path]} == "/" ]]
        then
            main_text=" ${disk_info[disk_info_path]} ${disk_info[disk_info_avail]} ${disk_info[disk_info_fuse]}";
        fi
    fi
done

# for disk in $disks;
# do
#     disk_info=$disk;
#     echo "Loop Found "$disk;
# done

echo "{\"text\": \"$main_text\", \"alt\": \"alt\", \"tooltip\": \"$tooltip_text\", \"class\": \"class\", \"percentage\": \"percentage\" }";