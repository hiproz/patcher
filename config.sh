#!/bin/bash
#################################### user config area #################################

# exclude file types of system
exclude_sys=(
*.zip
*.jar
*.tar
*.tar.gz
*.7z
*.bin
.gitignore
.svn
.git
)

# exclude file types of project
exclude_proj=(
*.o
*.ko
*.orig
*.rej
*.o.*
*.ko.*
*.order
*.symvers
.tmp_versions
*.mod.c
out
chromium*
*x86*
chromium
external
chipram
dump-all-packages.*
wilhelm
docs
toolchain
tools
)

# exclude file types of user
exclude_user=(
*.so
)

# diff task array format
# diff_task=(
# [new project full path]
# [old original project relative path]
# [system exclude array]
# [project exclude array]
# [user exclude array]
#)

task1=(
/home/a/dir1
./dir1
exclude_sys 
exclude_proj 
exclude_user
)

task2=(
/home/a/dir2
./dir2
exclude_sys 
exclude_proj 
exclude_user
)

task3=(
/home/a/dir3
./dir3
exclude_sys 
exclude_proj 
exclude_user
)

# diff task list
diff_tasks=(task3 task2 task1)
