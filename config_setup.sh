#!/bin/bash

echo "----- Start config script -----"

function configure_hyprland_wm {
    echo "";
    echo "Starting Hyprland configs!";

    echo "Creating Backup folder"
    mkdir "backup"

    for item_config in "rofi" "dunst" "hypr" "kitty" "pipewire" "swaylock" "waybar" "wlogout"
    do
        moving_creating_configs ${item_config}
    done

    echo "End config script"
    echo "-------------------------------------------------"
}

function moving_creating_configs  {
    user_home=~
    user_config_path="${user_home}/.config"
    config_repo=${PWD}
    config_backup="${config_repo}/backup"
    config_repo_local=${config_repo}/$1
    user_config_local=${user_config_path}/$1

    if [[ $1 == "hypr" ]]
    then
        repo_name="Hyprland";
    else
        repo_name="$1";
    fi

    echo "-------------------------------------------------"
    echo "-->Moving ${repo_name} files from ${user_config_local} to backup<--"
    mv -v "${user_config_local}" "${config_backup}"
    echo "--->Creating SisLink to ${repo_name} files of ${user_config_path}<---"
    ln -sv "${config_repo_local}" "${user_config_path}"
}

function restore_configs_backup {
    echo "-------------------------------------------------"
    echo "-->Moving files to home folder<--"

    list_backups="$(ls backup)";

    for item_backup in $list_backups
    do
        rm -rfv ~/.config/${item_backup};
        mv -v backup/${item_backup} ~/.config;
    done

    rm -r backup;
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
    # Greetings!
    echo "
###################################################################################################
|                                                                                                 |
|  Hi there!                                                                                      |
|                                                                                                 |
|  This script will update your dotfiles (.config, .local, etc) by retrieving the latest version  |
|  from the Git repository and then replacing the old config files with the updated ones.         |
|  To preserve your customizations, it will ask you if you wanna continue.                        |
|                                                                                                 |
###################################################################################################";

    read -rp "Do you want to continue? [y/n] " REPLY
    echo
    if [[ $REPLY =~ ^[yYsS]$ ]]
    then
        echo "Moving on...";
    else
        exit_script;
    fi

    # End of Greetings
    echo "";
    echo "-------------------------"
    echo "Choose wm to configure:";
    echo " 1 - I3 WM - Unavailable";
    echo " 2 - Hyprland WM";
    echo " 3 - Exit";

    read chosen_wm;
    echo "-------------------------"

    if [ $chosen_wm == 1 ]
    then
        #configure_i3_wm;
        choose_wm;
    elif [ $chosen_wm == 2 ]
    then
        configure_hyprland_wm;
    elif [ $chosen_wm == 3 ]
    then
        exit_script;
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

function choose_aur_helper {
    echo "-------------------------"
    echo "Choose AUR Helper:";
    echo " 1 - trizen";
    echo " 2 - Exit";

    read aur_helper;
    echo "-------------------------"

    if [ $aur_helper == 1 ]
    then
        install_trizen;
        export INSTALLER_AUR_HELPER="trizen"
    elif [ $aur_helper == 2 ]
    then
        exit_script;
    else 
        echo "";
        echo "-------------------------"        
        echo "--                     --";
        echo "--  Incorrect option!  --";
        echo "--                     --";
        echo "-------------------------";
        echo "";
        choose_aur_helper;
    fi
}

function check_installed_package {
    [[ -n $(pacman -Q $1) ]];
}

function install_trizen {

    if ! check_installed_package "git"
    then
        install_dependencies "git";
    fi

    if ! check_installed_package "trizen"
    then
        echo "Installing trizen from 'git clone https://aur.archlinux.org/trizen-git.git'";
        
        git clone "https://aur.archlinux.org/trizen-git.git"

        cd trizen-git

        makepkg -si
        
        cd ..

        echo "Removing trizen source files";

        rm -rfv trizen-git
    else
        echo "Trizen installed";
    fi
}

function install_dependencies {
    echo "";
    echo "Checking selected packages: $1";
    echo "";

    array=(`echo $1 | sed 's/ /\n/g'`)

    installed="";
    to_install="";

    for i in "${array[@]}";
    do
        if ! check_installed_package $i
        then
            to_install+=" $i";
        else
            installed+=" $i";
        fi
    done

    echo "Installed packages: $installed";

    if [[ -n $to_install ]] 
    then

        echo "Packages to install: $to_install";

        if [[ $INSTALLER_AUR_HELPER ]]
        then
            echo "AUR Help found, using $INSTALLER_AUR_HELPER!...";
            $INSTALLER_AUR_HELPER -Sq --noconfirm $to_install;
        else
            echo "AUR Help nor found, using regular pacman command!!!...";
            sudo pacman -Sq $to_install
        fi
    fi
    echo "";
}

function unset_env_variables {
    echo "";
    echo "Removing env variables";

    unset INSTALLER_AUR_HELPER
}

function exit_script {
    echo "";
    echo -e "${RED}Exiting...${RESET}"
    exit 0
}

function choose_tasks {
    echo "-------------------------"
    echo "Choose Task:";
    echo " 1 - Install AUR Helper";
    echo " 2 - Install dependencies";
    echo " 3 - Config WM";
    echo " 4 - Restore configs backup";
    echo " 5 - All tasks";
    echo " 6 - Exit";

    read task;
    echo "-------------------------"

    case $task in
        1)
            choose_aur_helper;
            choose_tasks;
            ;;
        2)
            #TODO: Install all dependencies...
            install_dependencies "rofi playerctl rofi-calc python-requests python kitty wlogout dunst hyprpicker waybar pavucontrol cliphist spotify code chromium swaylock wireplumber librnnoise-nu rnnoise noise-suppression-for-voice nerd-fonts blueman protonup-qt-bin";
            choose_tasks;
            ;;
        3)
            #TODO: Remove comment
            choose_wm;
            choose_tasks;
            ;;
        4)
            restore_configs_backup
            ;;
        5)
            choose_aur_helper;
            install_dependencies "rofi playerctl rofi-calc python-requests python kitty wlogout dunst hyprpicker waybar pavucontrol cliphist spotify code chromium swaylock wireplumber librnnoise-nu rnnoise noise-suppression-for-voice nerd-fonts blueman protonup-qt-bin";
            choose_wm;
            choose_tasks;
            ;;
        6)
            ## Simple exit
            ;;
        *)
            echo "";
            echo "-------------------------";
            echo "--                     --";
            echo "--  Incorrect option!  --";
            echo "--                     --";
            echo "-------------------------";
            echo "";
            choose_tasks;
        ;;
    esac
}

function init_config_installer {
    choose_tasks;

    unset_env_variables;

    echo "";
    echo "----- Ending config script -----"
}

init_config_installer;