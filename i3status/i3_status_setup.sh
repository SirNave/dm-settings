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

# Copying base config
cp /home/nave/Documents/development/workspace/nave/configuracoes/i3status/config_base /home/nave/Documents/development/workspace/nave/configuracoes/i3status/config;

for (( i=0; i<${#disks[@]}; i++ )); do
    disk_info=(${disks[i]});
    echo "Found "${disk_info[7]};
    disk_mapping="${disk_mapping}\ndisk \"${disk_info[7]}\" {\n   format = \" ⛁ ${disk_info[3]} %avail \"\n}\n";
    disk_monitoring="${disk_monitoring}order \+= \"disk ${disk_info[7]}\"\n";
done

disk_monitoring_replace="#DiskMonitoring";
disk_mapping_replace="#DiskMapping";

# Using ',' as a delimiter to avoid issues with '+', '=', '\' and '/'
sed -i "s,$disk_monitoring_replace,$disk_monitoring,g" /home/nave/Documents/development/workspace/nave/configuracoes/i3status/config;
sed -i "s,$disk_mapping_replace,$disk_mapping,g" /home/nave/Documents/development/workspace/nave/configuracoes/i3status/config;
echo "-------------------------------------------------"

# Store cpu temperatura index
cpu_temperature_index=0;
echo "Searching external gpu";
echo "-------------------------------------------------";

gpus=$(lspci | grep -i vga);

gpu_monitoring="";
gpu_mapping="";

for (( i=0; i<${#gpus[@]}; i++ )); do
    gpu_info=(${gpus[i]});
    echo "Found "${gpus[i]};

    gpu_temp_input="/sys/bus/pci/devices/0000:${gpu_info[0]}/hwmon/hwmon?/temp1_input";

    # Check if can get the temps
    if [ -f ${gpu_temp_input} ]
    then
        gpu_monitoring="${gpu_monitoring}order += \"cpu_temperature ${cpu_temperature_index}\"\n";
        gpu_mapping="${gpu_mapping}\ncpu_temperature ${cpu_temperature_index} {\nformat = \"🌡️ Gpu %degrees °C\"\path = \"${gpu_temp_input}\"\nmax_threshold = 65\n}";

        cpu_temperature_index=$((SUM=${cpu_temperature_index}+1));
        gpu_temp=$(cat ${gpu_temp_input});
    else
        echo "Can't acquire temperature!";
    fi
done

gpu_monitoring_replace="#GpuMonitoring";
gpu_mapping_replace="#GpuMapping";

sed -i "s,$gpu_monitoring_replace,$gpu_monitoring,g" /home/nave/Documents/development/workspace/nave/configuracoes/i3status/config;
sed -i "s,$gpu_mapping_replace,$gpu_mapping,g" /home/nave/Documents/development/workspace/nave/configuracoes/i3status/config;
echo "-------------------------------------------------"

echo "Searching cpu frequency";
echo "-------------------------------------------------";

echo "Trying get cpu frequency"
cpu_frequency_input="/sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq";

if [ -f ${cpu_frequency_input} ]
then
    cpu_frequency_mapping="\ncpu_temperature ${cpu_temperature_index} {\nformat = \" %degrees Mhz\"\path = \"${cpu_frequency_input}\"\nmax_threshold = 3500\n}";
    cpu_frequency_monitoring="order += \"cpu_temperature ${cpu_temperature_index}\"\n";

    cpu_frequency_monitoring_replace="#CpuFrequencyMonitoring";
    cpu_frequency_mapping_replace="#CpuFrequencyMapping";
    cpu_temperature_index=$((SUM=${cpu_temperature_index}+1));
  
    sed -i "s,$cpu_frequency_monitoring_replace,$cpu_frequency_monitoring,g" /home/nave/Documents/development/workspace/nave/configuracoes/i3status/config;
    sed -i "s,$cpu_frequency_mapping_replace,$cpu_frequency_mapping,g" /home/nave/Documents/development/workspace/nave/configuracoes/i3status/config;
else
    echo "Can't acquire cpu frequency!";
fi
echo "-------------------------------------------------";

echo "Searching nvme temperature";
echo "-------------------------------------------------";

nvmes=$(lspci | grep -i nvme);

nvme_monitoring="";
nvme_mapping="";

for (( i=0; i<${#nvmes[@]}; i++ )); do
    nvme_info=(${nvmes[i]});
    echo "Found "${nvmes[i]};

    nvme_temp_input="/sys/bus/pci/devices/0000:${nvme_info[0]}/hwmon/hwmon?/temp1_input";

    # Check if can get the temps
    if [ -f ${gpu_temp_input} ]
    then
        nvme_monitoring="${nvme_monitoring}order += \"cpu_temperature ${cpu_temperature_index}\"\n";
        nvme_mapping="${nvme_mapping}\ncpu_temperature ${cpu_temperature_index} {\nformat = \"🌡️ Nvme %degrees °C\"\path = \"${nvme_temp_input}\"\nmax_threshold = 65\n}";

        cpu_temperature_index=$((SUM=${cpu_temperature_index}+1));
    else
        echo "Can't acquire temperature!";
    fi
done

nvme_monitoring_replace="#NvmeMonitoring";
nvme_mapping_replace="#NvmeMapping";

sed -i "s,$nvme_monitoring_replace,$nvme_monitoring,g" /home/nave/Documents/development/workspace/nave/configuracoes/i3status/config;
sed -i "s,$nvme_mapping_replace,$nvme_mapping,g" /home/nave/Documents/development/workspace/nave/configuracoes/i3status/config;
echo "-------------------------------------------------"

echo "Searching cpu temperature";
echo "-------------------------------------------------";
cpu_temperature_mapping="";
cpu_temperature_monitoring="";

echo "Trying get cpu temperatures"
cpu_temp_input="/sys/bus/pci/devices/0000:00:18.3/hwmon/hwmon?/temp1_input";

if [ -f ${cpu_temp_input} ]
then
    cpu_temp_label=$(cat /sys/bus/pci/devices/0000:00:18.3/hwmon/hwmon?/temp1_label);
    cpu_temperature_mapping="${cpu_temperature_mapping}\ncpu_temperature ${cpu_temperature_index} {\nformat = \" ${cpu_temp_label} %degrees °C\"\path = \"${cpu_temp_input}\"\nmax_threshold = 65\n}";
    cpu_temperature_monitoring="${cpu_temperature_monitoring}order += \"cpu_temperature ${cpu_temperature_index}\"\n";
    cpu_temperature_index=$((SUM=${cpu_temperature_index}+1));
else
    echo "Can't acquire cpu temperature!";
fi

cpu_temp_input="/sys/bus/pci/devices/0000:00:18.3/hwmon/hwmon?/temp2_input";

if [ -f ${cpu_temp_input} ]
then
    cpu_temp_label=$(cat /sys/bus/pci/devices/0000:00:18.3/hwmon/hwmon?/temp2_label);
    cpu_temperature_mapping="${cpu_temperature_mapping}\ncpu_temperature ${cpu_temperature_index} {\nformat = \" ${cpu_temp_label} %degrees °C\"\path = \"${cpu_temp_input}\"\nmax_threshold = 65\n}";
    cpu_temperature_monitoring="${cpu_temperature_monitoring}order += \"cpu_temperature ${cpu_temperature_index}\"\n";
    cpu_temperature_index=$((SUM=${cpu_temperature_index}+1));
else
    echo "Can't acquire cpu temperature!";
fi

cpu_temp_input="/sys/bus/pci/devices/0000:00:18.3/hwmon/hwmon?/temp3_input";

if [ -f ${cpu_temp_input} ]
then
    cpu_temp_label=$(cat /sys/bus/pci/devices/0000:00:18.3/hwmon/hwmon?/temp3_label);
    cpu_temperature_mapping="${cpu_temperature_mapping}\ncpu_temperature ${cpu_temperature_index} {\nformat = \" ${cpu_temp_label} %degrees °C\"\path = \"${cpu_temp_input}\"\nmax_threshold = 65\n}";
    cpu_temperature_monitoring="${cpu_temperature_monitoring}order += \"cpu_temperature ${cpu_temperature_index}\"\n";
    cpu_temperature_index=$((SUM=${cpu_temperature_index}+1));
else
    echo "Can't acquire cpu temperature!";
fi

cpu_temperature_input="/sys/devices/platform/nct6775.656/hwmon/hwmon?/temp2_input";

if [ -f ${cpu_frequency_input} ]
then
    cpu_temperature_mapping="${cpu_temperature_mapping}\ncpu_temperature ${cpu_temperature_index} {\nformat = \" Cpu %degrees °C\"\path = \"${cpu_temperature_input}\"\nmax_threshold = 65\n}";
    cpu_temperature_monitoring="${cpu_temperature_monitoring}order += \"cpu_temperature ${cpu_temperature_index}\"\n";
    cpu_temperature_index=$((SUM=${cpu_temperature_index}+1));
else
    echo "Can't acquire cpu temperature!";
fi

cpu_temperature_monitoring_replace="#CpuTemperatureMonitoring";
cpu_temperature_mapping_replace="#CpuTemperatureMapping";

sed -i "s,$cpu_temperature_monitoring_replace,$cpu_temperature_monitoring,g" /home/nave/Documents/development/workspace/nave/configuracoes/i3status/config;
sed -i "s,$cpu_temperature_mapping_replace,$cpu_temperature_mapping,g" /home/nave/Documents/development/workspace/nave/configuracoes/i3status/config;
echo "-------------------------------------------------";

echo "I3Status setup finished";