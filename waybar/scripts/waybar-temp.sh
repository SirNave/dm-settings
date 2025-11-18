#!/bin/bash

base_path_temps='/sys/class/hwmon/';

oldifs="$IFS";
IFS=$'\n';
temps_to_check="$(ls ${base_path_temps})";
IFS="$oldifs";

main_text='';
tooltip_text='';

for hwmon_path in $temps_to_check
do
    temps_name=$(cat ${base_path_temps}${hwmon_path}'/name');
    new_input="$temps_name\n";

    temps_path=${base_path_temps}${hwmon_path}/temp?_input;

    new_line='';
    for temp_path in $temps_path
    do

        if [ -e $temp_path ];
        then
            if [ -e ${temp_path/input/label} ];
            then
                temp_label=$(cat ${temp_path/input/label});
            else
                temp_label='';
            fi
            
            temp_input=$(cat ${temp_path});
            temp_value="$(bc <<< "scale=2; ($temp_input/1000)")";
            new_line="$new_line$temp_label\t$temp_value°C\n";

            if [[ "$temp_label" == 'Tdie' || "$temp_label" == 'Package id 0' ]];
            then
                main_text=$temp_value
            fi
        fi
    done

    if [[ $new_line ]];
    then
        tooltip_text="$tooltip_text$new_input$new_line\n";
    fi
done

if [[ $main_text ]];
then
    main_text="<span font='Material Icons 12' rise='-3pt'>device_thermostat</span> $main_text°C"
else
    main_text="Error"
fi

echo "{\"text\": \"$main_text\", \"alt\": \"alt\", \"tooltip\": \"$tooltip_text\", \"class\": \"class\", \"percentage\": \"percentage\" }";