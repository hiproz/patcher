#!/bin/bash

# the file types of this tool that need to be ignored
exclude_tool=(
*.patch
patcher
patcher-*.sh
)

function get_str_from_array(){
    local array=$*
    local str=""

    for str_val in ${array[*]}
    do
        str=$str" -x $str_val"
    done
    echo " $str"
}

function get_new_path_from_task(){
    ## convert string to object
    eval local task_str=\${$1[*]}
    ## convert to array
    local task_arr=($task_str)
    
    echo "${task_arr[0]}"
}

function get_old_path_from_task(){
    eval local task_str=\${$1[*]}
    local task_arr=($task_str)
    echo "${task_arr[1]}"
}

function get_all_exclude_str(){

    eval local task_str=\${$1[*]}
    local task_arr=($task_str)
    
    eval local exclude_sys_array_name=\${${task_arr[2]}[*]}
    local exclude_sys_array=($exclude_sys_array_name)

    eval  local exclude_proj_array_name=\${${task_arr[3]}[*]}
    eval  local exclude_proj_array=($exclude_proj_array_name)

    eval  local exclude_user_array_name=\${${task_arr[4]}[*]}
    eval  local exclude_user_array=($exclude_user_array_name)

    local str=$(get_str_from_array ${exclude_sys_array[*]})$(get_str_from_array ${exclude_proj_array[*]})$(get_str_from_array ${exclude_user_array[*]})$(get_str_from_array ${exclude_tool[*]})

    echo "$str"
}