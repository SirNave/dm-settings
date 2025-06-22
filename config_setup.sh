#!/bin/bash

echo "----- Start config script -----"

function configure_hyprland_wm {
    echo "";
    echo "Starting Hyprland configs!";

    backup_path="backup";

    echo "Creating Backup folder"
    if [[ -e $backup_path ]]
    then
        echo "-->Backup Exist, create by date<--"
        backup_path+="_$(date +"%Y-%m-%d_%H-%M-%S")";
    fi

    echo "-->Creating backup path - ${backup_path}<--"
    mkdir "${backup_path}"

    for item_config in "dunst" "hypr" "kitty" "pipewire" "rofi" "waybar" "wlogout" "mimeapps.list"
    do
        moving_creating_configs "${item_config}" "${backup_path}"
    done

    echo "End config script"
    echo "-------------------------------------------------"
}

function moving_creating_configs  {
    user_home=~
    user_config_path="${user_home}/.config"
    config_repo=${PWD}
    config_backup="${config_repo}/$2"
    config_repo_local=${config_repo}/$1
    user_config_local=${user_config_path}/$1

    if [[ $1 == "hypr" ]]
    then
        repo_name="Hyprland";
    else
        repo_name="$1";
    fi
    
    move_to_backup=true;

    echo "-------------------------------------------------"
    echo "-->Check ${user_config_local}<--"
    if [[ -e $user_config_local ]]
    then
        echo "--->File exists<---"
        echo "--->Test ${user_config_local} to SisLink<---"
        if [[ -L $user_config_local ]]
        then
            echo "---->SisLink<----"
            read_sislink=$(readlink "$user_config_local")
            echo "---->${read_sislink}<----"
            if [[ "$read_sislink" == "$config_repo_local" ]]
            then
                echo "----->Same repository of backup<-----"
                move_to_backup=false;
            else
                echo "----->Different repository<-----"
            fi
        else
            echo "---->False<----"
        fi
    else
        echo "--->Missing file<--"
        move_to_backup=false;
    fi

    if [[ "$move_to_backup" == "true" ]];
    then
        echo "-->Moving ${repo_name} files from ${user_config_local} to backup<--"
        mv -v "${user_config_local}" "${config_backup}"
    fi

    echo "--->Creating SisLink to ${repo_name} files of ${user_config_path}<---"
    ln -sv "${config_repo_local}" "${user_config_path}"
}

function restore_configs_backup {
    echo "-------------------------------------------------"
    echo "-->Moving files to home folder<--"

    list_backups="$(ls backup)";

    for item_backup in $list_backups
    do
        rm -rfv ~/.config/"${item_backup}";
        mv -v backup/"${item_backup}" ~/.config;
    done

    rm -r backup;
}

function choose_wm {
    echo ""
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
        return;
    fi

    # End of Greetings
    echo "";
    echo "-------------------------"
    echo "Choose wm to configure:";
    echo " 1 - Hyprland WM";
    echo " 2 - Exit";

    read -r chosen_wm;
    echo "-------------------------"

    case $chosen_wm in
        1)
            configure_hyprland_wm;
            ;;
        2)
            exit_script;
            ;;
        *)
            echo "";
            echo "-------------------------";
            echo "--                     --";
            echo "--  Incorrect option!  --";
            echo "--                     --";
            echo "-------------------------";
            echo "";
            choose_wm;
        ;;
    esac
}

function choose_aur_helper {
    echo "-------------------------"
    echo "Choose AUR Helper:";
    echo " 1 - trizen";
    echo " 2 - Exit";

    read -r aur_helper;
    echo "-------------------------"

    case $aur_helper in
        1)
            install_trizen;
            ;;
        2)
            exit_script;
            ;;
        *)
            echo "";
            echo "-------------------------";
            echo "--                     --";
            echo "--  Incorrect option!  --";
            echo "--                     --";
            echo "-------------------------";
            echo "";
            choose_aur_helper;
        ;;
    esac
}

function check_trizen_aur_helper {
    if check_installed_package "trizen"
    then
        export INSTALLER_AUR_HELPER="trizen";
    fi

}

function check_installed_package {
    [[ -n $(pacman -Q "$1") ]];
}

function install_trizen {
    if ! check_installed_package "trizen"
    then
        if ! check_installed_package "git"
        then
            install_dependencies "git";
        fi

        echo "Installing trizen from 'https://aur.archlinux.org/trizen-git.git'";
        
        git clone "https://aur.archlinux.org/trizen-git.git"

        cd trizen-git || exit

        makepkg -si
        
        cd ..

        echo "Removing trizen source files";

        rm -rfv trizen-git
    else
        echo "Trizen installed";
    fi
    
    check_trizen_aur_helper;
}

function install_dependencies {
    check_trizen_aur_helper;

    if [[ ! $INSTALLER_AUR_HELPER ]]
    then
        choose_aur_helper;
    fi

    setup_packages_to_install;

    IFS=" " read -r -a array <<< "$APP_TO_INSTALL";

    installed="";
    to_install="";

    for i in "${array[@]}";
    do
        echo "----- Checking $i -----"
        if ! check_installed_package "$i"
        then
            to_install+=" $i";
        else
            installed+=" $i";
        fi
    done

    echo "----- Installed packages: $installed";

    if [[ -n $to_install ]] 
    then

        echo "----- Packages to install: $to_install";

        if [[ $INSTALLER_AUR_HELPER ]]
        then
            echo "----- AUR Help found, using $INSTALLER_AUR_HELPER!...";
            
            $INSTALLER_AUR_HELPER -Sq --noconfirm $to_install;
        else
            echo "----- AUR Help not found, using regular pacman command!!!...";
            sudo pacman -Sq "$to_install"
        fi
    fi
    echo "";
    echo "-----< System Ready to Run >-----";
    echo "";
}

function unset_env_variables {
    echo "";
    echo "Removing env variables";

    unset INSTALLER_AUR_HELPER;
    unset APP_TO_INSTALL;
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

    read -r task;
    echo "-------------------------"

    case $task in
        1)
            choose_aur_helper;
            choose_tasks;
            ;;
        2)
            #TODO: Install all dependencies...
            install_dependencies;
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
            install_dependencies;
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

function setup_packages_to_install {
    hypland_packages=" hyprland hypridle hyprlock hyprpicker xdg-desktop-portal-hyprland hyprpaper hyprsunset"
    hypland_packages+=" hyprpolkitagent hyprlang hyprutils hyprland-qt-support aquamarine hyprgraphics hyprland-qtutils";

    rofi_packages=" rofi rofi-calc";

    pipewire_packages=" pipewire pavucontrol wireplumber librnnoise-nu rnnoise noise-suppression-for-voice";

    players_packages=" spotify playerctl";

    theme_packages=" kvantum kvantum-qt5 kvantum-theme-materia";

    fonts_packages=" ttf-font-awesome ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-common ttf-nerd-fonts-symbols-mono ttf-dejavu noto-fonts noto-fonts-emoji ttf-liberation"; # TODO - Verify fonts to install
    
    bluetooth_packages=" blueberry blueman";

    wayland_utilities_packages=" wlsunset wlogout waybar qt5-wayland qt6-wayland xwaylandvideobridge cliphist ranger";

    utilities_packages=" network-manager-applet grim slurp dunst bc brightnessctl python-requests python kitty qalculate-gtk viewnior";

    game_utilities_packages=" steam protonup-qt-bin heroic-games-launcher-bin vkd3d lib32-vkd3d wine wine-mono winetricks";

    amd_game_utilities_packages=" amd-ucode amf-headers composable-kernel hip-runtime-amd amd-vulkan-prefixes";
    amd_game_utilities_packages+=" vulkan-radeon lib32-vulkan-radeon ";

    browser_packages=" chromium";

    dev_packages=" code git";

    apps_install="$hypland_packages";
    apps_install+="$rofi_packages";
    apps_install+="$pipewire_packages";
    apps_install+="$players_packages";
    apps_install+="$theme_packages";
    apps_install+="$fonts_packages";
    apps_install+="$bluetooth_packages";
    apps_install+="$wayland_utilities_packages";
    apps_install+="$utilities_packages";
    apps_install+="$browser_packages";

    echo "-------------------------"
    echo "Install game utilities?";
    echo " 1 - Yes";
    echo " 0 - No";
    
    read -r read_game;

    case $read_game in
        1)
            apps_install+="$game_utilities_packages";
            ;;
    esac
    echo "-------------------------"

    echo "-------------------------"
    echo "Install AMD game utilities?";
    echo " 1 - Yes";
    echo " 0 - No";
    
    read -r read_amd;

    case $read_amd in
        1)
            apps_install+="$amd_game_utilities_packages";
            ;;
    esac
    echo "-------------------------"
    
    echo "-------------------------"
    echo "Install development utilities?";
    echo " 1 - Yes";
    echo " 0 - No";
    
    read -r read_dev;

    case $read_dev in
        1)
            apps_install+="$dev_packages";
            ;;
    esac
    echo "-------------------------"
    
    echo "-------------------------"
    echo "Install Logitech Solaar utilitie?";
    echo " 1 - Yes";
    echo " 0 - No";
    
    read -r read_logitech;

    case $read_logitech in
        1)
            apps_install+=" solaar";
            ;;
    esac
    echo "-------------------------"
    
    echo "-------------------------"
    echo "Install Corsair Mouse/Keyboard utilitie?";
    echo " 1 - Yes";
    echo " 0 - No";
    
    read -r read_corsair;

    case $read_corsair in
        1)
            apps_install+=" ckb-next";
            ;;
    esac
    echo "-------------------------"

    export APP_TO_INSTALL=$apps_install;
}

function init_config_installer {
    choose_tasks;

    unset_env_variables;

    echo "";
    echo "----- Ending config script -----";
}

init_config_installer;
