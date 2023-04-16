#!/bin/bash

echo "----- Start config script -----"

function configure_hyprland_wm {
    echo "";
    echo "Starting Hyprland configs!";
    
    rofi_path="/rofi"
    dunst_path="/dunst"
    hypr_path="/hypr"
    kitty_path="/kitty"
    pipewire_path="/pipewire"
    swaylock_path="/swaylock"
    waybar_path="/waybar"
    wlogout_path="/wlogout"

    user_home=~
    user_config_path="${user_home}/.config"
    config_repo=${PWD}

    config_repo_rofi=${config_repo}${rofi_path}
    user_config_rofi=${user_config_path}${rofi_path}
    config_repo_dunst=${config_repo}${dunst_path}
    user_config_dunst=${user_config_path}${dunst_path}
    config_repo_hypr=${config_repo}${hypr_path}
    user_config_hypr=${user_config_path}${hypr_path}
    config_repo_kitty=${config_repo}${kitty_path}
    user_config_kitty=${user_config_path}${kitty_path}
    config_repo_pipewire=${config_repo}${pipewire_path}
    user_config_pipewire=${user_config_path}${pipewire_path}
    config_repo_swaylock=${config_repo}${swaylock_path}
    user_config_swaylock=${user_config_path}${swaylock_path}
    config_repo_waybar=${config_repo}${waybar_path}
    user_config_waybar=${user_config_path}${waybar_path}
    config_repo_wlogout=${config_repo}${wlogout_path}
    user_config_wlogout=${user_config_path}${wlogout_path}

    echo "User HOME = ${user_home}"
    echo "User configs patch = ${user_config_path}"
    echo "User configs repo = ${config_repo}"

    echo "-------------------------------------------------"
    echo "-->Removing rofi files from ${user_config_rofi}<--"
    rm -rfv "${user_config_rofi}"
    echo "--->Creating SisLink to rofi files of ${config_repo_rofi}<---"

    ln -sv "${config_repo_rofi}" "${user_config_path}"

    echo "-------------------------------------------------"
    echo "-->Removing dunst files from ${user_config_dunst}<--"
    rm -rfv "${user_config_dunst}"
    echo "--->Creating SisLink to dunst files of ${config_repo_dunst}<---"

    ln -sv "${config_repo_dunst}" "${user_config_path}"

    echo "-------------------------------------------------"
    echo "-->Removing hypr files from ${user_config_hypr}<--"
    rm -rfv "${user_config_hypr}"
    echo "--->Creating SisLink to hypr files of ${config_repo_hypr}<---"

    ln -sv "${config_repo_hypr}" "${user_config_path}"

    echo "-------------------------------------------------"
    echo "-->Removing kitty files from ${user_config_kitty}<--"
    rm -rfv "${user_config_kitty}"
    echo "--->Creating SisLink to kitty files of ${config_repo_kitty}<---"

    ln -sv "${config_repo_kitty}" "${user_config_path}"

    echo "-------------------------------------------------"
    echo "-->Removing pipewire files from ${user_config_pipewire}<--"
    rm -rfv "${user_config_pipewire}"
    echo "--->Creating SisLink to pipewire files of ${config_repo_pipewire}<---"

    ln -sv "${config_repo_pipewire}" "${user_config_path}"

    echo "-------------------------------------------------"
    echo "-->Removing swaylock files from ${user_config_swaylock}<--"
    rm -rfv "${user_config_swaylock}"
    echo "--->Creating SisLink to swaylock files of ${config_repo_swaylock}<---"

    ln -sv "${config_repo_swaylock}" "${user_config_path}"

    echo "-------------------------------------------------"
    echo "-->Removing waybar files from ${user_config_waybar}<--"
    rm -rfv "${user_config_waybar}"
    echo "--->Creating SisLink to waybar files of ${config_repo_waybar}<---"

    ln -sv "${config_repo_waybar}" "${user_config_path}"

    echo "-------------------------------------------------"
    echo "-->Removing wlogout files from ${user_config_wlogout}<--"
    rm -rfv "${user_config_wlogout}"
    echo "--->Creating SisLink to wlogout files of ${config_repo_wlogout}<---"

    ln -sv "${config_repo_wlogout}" "${user_config_path}"

    echo "End config script"
    echo "-------------------------------------------------"
}

function configure_i3_wm {
    echo "";
    echo "Starting I3 configs!";
    
    i3_path="/i3"
    rofi_path="/rofi"
    i3status_path="/i3status"
    i3netSpeed_path="/i3netSpeed"

    user_home=~
    user_config_path="${user_home}/.config"
    config_repo=${PWD}

    config_repo_i3netSpeed=${config_repo}${i3netSpeed_path}
    user_config_i3netSpeed=${user_config_path}${i3netSpeed_path}
    config_repo_i3status=${config_repo}${i3status_path}
    user_config_i3status=${user_config_path}${i3status_path}
    config_repo_i3=${config_repo}${i3_path}
    user_config_i3=${user_config_path}${i3_path}
    config_repo_rofi=${config_repo}${rofi_path}
    user_config_rofi=${user_config_path}${rofi_path}

    echo "-------------------------------------------------"
    echo "Run I3Status setup"
    ./i3status/i3_status_setup.sh
    echo "-------------------------------------------------"

    echo "User HOME = ${user_home}"
    echo "User configs patch = ${user_config_path}"
    echo "User configs repo = ${config_repo}"

    echo "-------------------------------------------------"
    echo "-->Removing netSpeed files from ${user_config_i3netSpeed}<--"
    rm -rfv "${user_config_i3netSpeed}"
    echo "--->Creating SisLink to netSpeed files of ${config_repo_i3netSpeed}<---"

    ln -sv "${config_repo_i3netSpeed}" "${user_config_path}"

    echo "-------------------------------------------------"
    echo "-->Removing i3 files from ${user_config_i3}<--"
    rm -rfv "${user_config_i3}"
    echo "--->Creating SisLink to i3 files of ${config_repo_i3}<---"

    ln -sv "${config_repo_i3}" "${user_config_path}"

    echo "-------------------------------------------------"
    echo "-->Removing i3Status files from ${user_config_i3status}<--"
    rm -rfv "${user_config_i3status}"
    echo "--->Creating SisLink to i3Status files of ${config_repo_i3status}<---"

    ln -sv "${config_repo_i3status}" "${user_config_path}"

    echo "-------------------------------------------------"
    echo "-->Removing rofi files from ${user_config_rofi}<--"
    rm -rfv "${user_config_rofi}"
    echo "--->Creating SisLink to rofi files of ${config_repo_rofi}<---"

    ln -sv "${config_repo_rofi}" "${user_config_path}"

    echo "End config script"
    echo "-------------------------------------------------"

    echo "Restarting I3"
    i3-msg restart
    echo "-------------------------------------------------"
}

function choose_wm {
    echo "";
    echo "-------------------------"
    echo "Choose wm to configure:";
    echo " 1 - I3 WM";
    echo " 2 - Hyprland WM";

    read chosen_wm;
    echo "-------------------------"

    if [ $chosen_wm == 1 ]
    then
        configure_i3_wm;
    elif [ $chosen_wm == 2 ]
    then
        configure_hyprland_wm;
    else 
        echo "";
        echo "-------------------------";
        echo "--                     --";
        echo "--  Incorrect option!  --";
        echo "--                     --";
        echo "-------------------------";
        choose_wm;
    fi
}

choose_wm;