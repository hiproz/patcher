#!/bin/bash
. ./common.sh
. ./blog.sh
. ./config-test.sh 

## show changed file list
./list.sh

logr "============================================ start differing files... ====================================================================="

# delete old patches
rm -rf ./*.patch
rm -rf ../*.patch

cd ..

patch_dir_name="`date +%Y%m%d%H%M%S`.patch"
logd $patch_dir_name

mkdir -p ./patcher/$patch_dir_name
echo -e "#!/bin/bash\ncd .." > ./patcher/$patch_dir_name/patch-add-all.sh
echo -e "#!/bin/bash\ncd .." > ./patcher/$patch_dir_name/patch-reverse-all.sh

patch_add_script="patch-add.sh"
patch_rev_script="patch-reverse.sh"
patch_review="review.patch"

# create review file
touch ./patcher/$patch_dir_name/$patch_review

task_index=0
for task in ${diff_tasks[*]}
do
    logr "============== start ${task_index}th task... ================"

    new_path=$(get_new_path_from_task $task)
    logd new path:$new_path

    old_path=$(get_old_path_from_task $task)
    logd old path:$old_path

    # task patch dir
    task_patch_dir_name=$patch_dir_name"/"$task
    patch_name=$(basename $new_path)
    logd $task_patch_dir_name $patch_name
    mkdir -p ./patcher/$task_patch_dir_name
    
    exclude_str=""
    exclude_str=$exclude_str$(get_all_exclude_str $task)
    logd exclude str:$exclude_str 

    logr start differing...
    cmd="diff -uNr $exclude_str $old_path $new_path"
    echo "$cmd"

    eval $cmd > ./patcher/$task_patch_dir_name/$patch_name.patch
    
    cat ./patcher/$task_patch_dir_name/$patch_name.patch >> ./patcher/$patch_dir_name/$patch_review
    
    logr start updating one key patch script...

    # update patch script
    # temp_path=$old_path
    # logd $temp_path
    # temp_path=${temp_path//\// } # string replace
    # array=(${temp_path//./ })
    # logd path array:${#array[*]}
    # path_depth=$((${#array[*]}+0))
    path_depth=0

    cmd="patch -N -p$path_depth < ./$task_patch_dir_name/$patch_name.patch"
    logd $cmd
    echo "#!/bin/bash" > ./patcher/$task_patch_dir_name/$patch_add_script
    echo $cmd >> ./patcher/$task_patch_dir_name/$patch_add_script

    cmd="patch -N -R -p$path_depth < ./$task_patch_dir_name/$patch_name.patch"
    logd $cmd
    echo "#!/bin/bash" > ./patcher/$task_patch_dir_name/$patch_rev_script
    echo $cmd >> ./patcher/$task_patch_dir_name/$patch_rev_script

    echo ./$task_patch_dir_name/$patch_add_script >> ./patcher/$patch_dir_name/patch-add-all.sh
    echo ./$task_patch_dir_name/$patch_rev_script >> ./patcher/$patch_dir_name/patch-reverse-all.sh

    let task_index+=1
done
chmod -R +x $(find ./patcher/$patch_dir_name -name "*.sh")

# backup
cp -r ./patcher/$patch_dir_name ./patcher/patch-bak
mv ./patcher/$patch_dir_name .

# remove the failed patch temp files
logd $old_path
find $old_path -regex ".*\.orig\|.*\.rej" |xargs rm -rf

logr done!
