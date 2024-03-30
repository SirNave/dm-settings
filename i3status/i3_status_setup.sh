#!/bin/bash

echo "-------------------------------------------------";
echo "Starting I3Status setup";
echo "-------------------------------------------------";

echo "Searching ext4 blocks";
echo "-------------------------------------------------";
oldifs="$IFS";
IFS=$'\n';
disks=($(lsblk -f | grep -i ext4));
IFS="$oldifs";

disk_monitoring="";
disk_mapping="";


config_repo_i3status=${PWD};

# Copying base config
cp "${config_repo_i3status}/i3status/config_base" "${config_repo_i3status}/i3status/config";

for (( i=0; i<${#disks[@]}; i++ )); do
    disk_info=(${disks[i]});
    echo "Found "${disks[i]};

    disk_info_path=7;
    disk_info_label=3;
    # Check disks without label
    if [ ${#disk_info[@]} == 7 ]
    then
        disk_info_path=6;
        disk_info_label=6;
    fi

    if [ ${#disk_info[@]} -ge 7 ]
    then
        disk_mapping="${disk_mapping}\ndisk \"${disk_info[disk_info_path]}\" {\n        format = \" ⛁ ${disk_info[disk_info_label]} %avail \"\n}\n";
        disk_monitoring="${disk_monitoring}order \+= \"disk ${disk_info[disk_info_path]}\"\n";
    else
        echo "Partition aparentely as not mounted"
    fi
done

disk_monitoring_replace="#DiskMonitoring";
disk_mapping_replace="#DiskMapping";

if [ ! -z "${disk_monitoring}" ]
then
    # Using ',' as a delimiter to avoid issues with '+', '=', '\' and '/'
    sed -i "s,$disk_monitoring_replace,$disk_monitoring,g" "${config_repo_i3status}/i3status/config";
    sed -i "s,$disk_mapping_replace,$disk_mapping,g" "${config_repo_i3status}/i3status/config";
fi
echo "-------------------------------------------------"

# Store cpu temperatura index
cpu_temperature_index=0;
echo "Searching external gpu";
echo "-------------------------------------------------";

IFS=$'\n';
gpus=($(lspci | grep -i vga));
IFS="$oldifs";

gpu_monitoring="";
gpu_mapping="";

for (( i=0; i<=${#gpus[@]}; i++ )); do
    gpu_info=(${gpus[i]});
    echo "Found "${gpus[i]};

    gpu_temp_input="/sys/bus/pci/devices/0000:${gpu_info[0]}/hwmon/hwmon?/temp1_input";

    echo "${gpu_temp_input}";

    # Check if can get the temps
    if [ -f ${gpu_temp_input} ]
    then
        gpu_monitoring="${gpu_monitoring}order += \"cpu_temperature ${cpu_temperature_index}\"";
        gpu_mapping="${gpu_mapping}\ncpu_temperature ${cpu_temperature_index} {\n        format = \"Gpu %degrees °C\"\n        path = \"${gpu_temp_input}\"\n        max_threshold = 65\n}";

        cpu_temperature_index=$((SUM=${cpu_temperature_index}+1));
    else
        echo "Can't acquire gpu temperature!";
    fi
done

gpu_monitoring_replace="#GpuMonitoring";
gpu_mapping_replace="#GpuMapping";

if [ ! -z "${gpu_monitoring}" ]
then
    sed -i "s,$gpu_monitoring_replace,$gpu_monitoring,g" "${config_repo_i3status}/i3status/config";
    sed -i "s,$gpu_mapping_replace,$gpu_mapping,g" "${config_repo_i3status}/i3status/config";
fi
echo "-------------------------------------------------"

echo "Searching cpu frequency";
echo "-------------------------------------------------";

echo "Trying get cpu frequency"
cpu_frequency_input="/sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq";

if [ -f ${cpu_frequency_input} ]
then
    cpu_frequency_mapping="cpu_temperature ${cpu_temperature_index} {\n        format = \" %degrees Mhz\"\n        path = \"${cpu_frequency_input}\"\n        max_threshold = 3500\n}";
    cpu_frequency_monitoring="order += \"cpu_temperature ${cpu_temperature_index}\"";

    cpu_frequency_monitoring_replace="#CpuFrequencyMonitoring";
    cpu_frequency_mapping_replace="#CpuFrequencyMapping";
    cpu_temperature_index=$((SUM=${cpu_temperature_index}+1));
  
    sed -i "s,$cpu_frequency_monitoring_replace,$cpu_frequency_monitoring,g" "${config_repo_i3status}/i3status/config";
    sed -i "s,$cpu_frequency_mapping_replace,$cpu_frequency_mapping,g" "${config_repo_i3status}/i3status/config";
else
    echo "Can't acquire cpu frequency!";
fi
echo "-------------------------------------------------";

echo "Searching nvme temperature";
echo "-------------------------------------------------";

IFS=$'\n';
nvmes=($(lspci | grep -i Non-Volatile));
IFS="$oldifs";

if [ ! -z "${nvmes}" ]
then
    nvme_monitoring="";
    nvme_mapping="";

    for (( i=0; i<${#nvmes[@]}; i++ )); do
        nvme_info=(${nvmes[i]});
        echo "Found "${nvmes[i]};

        nvme_temp_input="/sys/bus/pci/devices/0000:${nvme_info[0]}/nvme/nvme?/hwmon?/temp1_input";

        # Check if can get the temps
        if [ -f ${nvme_temp_input} ]
        then
            nvme_monitoring="${nvme_monitoring}order += \"cpu_temperature ${cpu_temperature_index}\"";
            nvme_mapping="${nvme_mapping}\ncpu_temperature ${cpu_temperature_index} {\n        format = \"Nvme %degrees °C\"\n        path = \"${nvme_temp_input}\"\n        max_threshold = 65\n}";

            cpu_temperature_index=$((SUM=${cpu_temperature_index}+1));
        else
            echo "Can't acquire ${nvmes[i]} temperature!";
        fi
    done

    nvme_monitoring_replace="#NvmeMonitoring";
    nvme_mapping_replace="#NvmeMapping";

    if [ ! -z "${nvme_monitoring}" ]
    then
        sed -i "s,$nvme_monitoring_replace,$nvme_monitoring,g" "${config_repo_i3status}/i3status/config";
        sed -i "s,$nvme_mapping_replace,$nvme_mapping,g" "${config_repo_i3status}/i3status/config";
    fi
else
    echo "Can't acquire nvme temperature!";
fi
echo "-------------------------------------------------"

echo "Searching cpu temperature";
echo "-------------------------------------------------";
cpu_temperature_mapping="";
cpu_temperature_monitoring="";

echo "Trying get cpu temperatures"
echo "-------------------------------------------------";

echo "Searching Cpu Temps";
echo "-------------------------------------------------";

oldifs="$IFS";
IFS=$'\n';
cpus_temp=($(ls /sys/bus/pci/devices/0000:00:18.3/hwmon/hwmon?/temp?_input));
IFS="$oldifs";

for (( i=0; i<${#cpus_temp[@]}; i++ )); do
    cpu_temp_input=(${cpus_temp[i]});
    cpu_temp_label=($(cat ${cpus_temp[i]//input/label}));

    echo "Found "$cpu_temp_input;
    echo "Label "$cpu_temp_label;

    cpu_temperature_mapping="${cpu_temperature_mapping}\ncpu_temperature ${cpu_temperature_index} {\n        format = \" ${cpu_temp_label} %degrees °C\"\n        path = \"${cpu_temp_input}\"\n        max_threshold = 65\n}\n";
    cpu_temperature_monitoring="${cpu_temperature_monitoring}order += \"cpu_temperature ${cpu_temperature_index}\"\n";
    cpu_temperature_index=$((SUM=${cpu_temperature_index}+1));    
done

cpu_temperature_input="/sys/devices/platform/nct6775.656/hwmon/hwmon?/temp2_input";

if [ -f ${cpu_temperature_input} ]
then
    cpu_temperature_mapping="${cpu_temperature_mapping}\ncpu_temperature ${cpu_temperature_index} {\n        format = \" Cpu %degrees °C\"\n        path = \"${cpu_temperature_input}\"\n        max_threshold = 65\n}\n";
    cpu_temperature_monitoring="${cpu_temperature_monitoring}order += \"cpu_temperature ${cpu_temperature_index}\"";
    cpu_temperature_index=$((SUM=${cpu_temperature_index}+1));
else
    echo "Can't acquire motherboard temperature!";
fi

cpu_intel_temp_input="/sys/devices/platform/coretemp.0/hwmon/hwmon?/temp2_input";

if [ -f ${cpu_intel_temp_input} ]
then
    cpu_temperature_mapping="${cpu_temperature_mapping}\ncpu_temperature ${cpu_temperature_index} {\n        format = \" Cpu %degrees °C\"\n        path = \"${cpu_intel_temp_input}\"\n        max_threshold = 65\n}\n";
    cpu_temperature_monitoring="${cpu_temperature_monitoring}order += \"cpu_temperature ${cpu_temperature_index}\"\n";
    cpu_temperature_index=$((SUM=${cpu_temperature_index}+1));
else
    echo "Can't acquire cpu temperature!";
fi

cpu_temperature_monitoring_replace="#CpuTemperatureMonitoring";
cpu_temperature_mapping_replace="#CpuTemperatureMapping";


if [ ! -z "${cpu_temperature_monitoring}" ]
then
    sed -i "s,$cpu_temperature_monitoring_replace,$cpu_temperature_monitoring,g" "${config_repo_i3status}/i3status/config";
    sed -i "s,$cpu_temperature_mapping_replace,$cpu_temperature_mapping,g" "${config_repo_i3status}/i3status/config";
fi
echo "-------------------------------------------------";

echo "Searching wifi";
echo "-------------------------------------------------";

IFS=$'\n';
wifi=($(lspci | grep -i wireless));
IFS="$oldifs";

if [ ! -z "${wifi}" ]
then
    echo "Found "${wifi[0]};
    
    wifi_monitoring_replace="#WirelessMonitoring";
    wifi_monitoring="order += \"wireless _first_\"";
    
    sed -i "s,$wifi_monitoring_replace,$wifi_monitoring,g" "${config_repo_i3status}/i3status/config";
else
    echo "No Wireless network found";    
fi
echo "-------------------------------------------------";

echo "Searching battery";
echo "-------------------------------------------------";

IFS=$'\n';
battery=($(acpi -ib | awk '!/power_supply/'));
IFS="$oldifs";

if [ ! -z "${battery}" ]
then
    echo "Found "${battery[0]};
    
    battery_monitoring_replace="#BatteryMonitoring";
    battery_monitoring="order += \"battery all\"";
    
    sed -i "s,$battery_monitoring_replace,$battery_monitoring,g" "${config_repo_i3status}/i3status/config";
else
    echo "No battery found";    
fi

echo "-------------------------------------------------";
