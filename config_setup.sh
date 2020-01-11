#!/bin/bash

echo "Start config script"

i3_path="/i3"
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

echo "User HOME = ${user_home}"
echo "User configs patch = ${user_config_path}"
echo "User configs repo = ${config_repo}"

echo "-------------------------------------------------"
echo "-->Removing netSpeed files from ${user_config_i3netSpeed}<--"
rm -rfv "${user_config_i3netSpeed}"
echo "--->Creating SisLink to netSpeed files of ${config_repo_i3netSpeed}<---"

ln -sv "${config_repo_i3netSpeed}" "${user_config_path}"

echo "-------------------------------------------------"
echo "-->Removing netSpeed files from ${user_config_i3}<--"
rm -rfv "${user_config_i3}"
echo "--->Creating SisLink to netSpeed files of ${config_repo_i3}<---"

ln -sv "${config_repo_i3}" "${user_config_path}"

echo "-------------------------------------------------"
echo "-->Removing netSpeed files from ${user_config_i3status}<--"
rm -rfv "${user_config_i3status}"
echo "--->Creating SisLink to netSpeed files of ${config_repo_i3status}<---"

ln -sv "${config_repo_i3status}" "${user_config_path}"

echo "End config script"
