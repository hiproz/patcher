#!/bin/bash
. ./common.sh
. ./blog.sh
. ./config-test.sh

logr "============================================ start listing changed files... ====================================================================="

cd ..

work_dir=$(pwd)
echo work dir:$work_dir

# clear change-list.txt 
>./patcher/change-list.txt

task_index=0
for task in ${diff_tasks[*]}
do
    logr "============== check ${task_index}th task... ================"

    new_path=$(get_new_path_from_task $task)
    logd new path:$new_path
 
    old_path=$(get_old_path_from_task $task)
    logd old path:$old_path

    exclude_str=""
    exclude_str=$exclude_str$(get_all_exclude_str $task)
    logd exclude str:$exclude_str 

    logd start differing...
    cmd="diff -qNr $exclude_str $old_path $new_path"
    echo "$cmd"

    eval $cmd >> ./patcher/change-list.txt

    let task_index+=1
done

logr "============== show the change file list ================"
cat ./patcher/change-list.txt