[中文 README](./README_CN.md)

# patcher

A patch toolset for one-click generation of patches and automation scripts

## Features

1. Support complex directory combinations
2. Each path generates a separate patch
3. Support one-click update all patches and undo all patches
4. Convenient and flexible filter type configuration (configuration file is an array in bash format)

## background knowledge

### diff command parameters

- r: recursive, after setting diff will compare all corresponding files in source code directories of two different versions, including subdirectory files
- N: Make sure the patch file will correctly handle the case where a file has already been created or deleted
- u: all-in-one diff output

### patch command parameters

- p Num: ignore several layers of folders, and then explain in detail
- E: indicates that if an empty file is found, then delete it
- R: Cancel the patch that has been hit

###patch related commands

Patch: patch -p1 < xxx.patch
Unpatch: patch -R -p1 < xxx.patch

## Patch making

1. Put `patcher` at the appropriate level of the original job (upper level of all modifications)
2. Modify `config.sh` to set the appropriate filter type
3. Run `different.sh`
4. The patch file xxx.patch folder will be generated outside the pather directory, side by side with the patcher directory

## Patch usage

Place the `xxx.patch` directory in the same directory hierarchy as when generating the patch

### Fully patched

````
./patch-add-all.sh
````

### Full undo patch

````
./patch-reverse-all.sh
````

### Operates on each patch individually

We call each patch a patch task. When a patch needs to be operated and tested separately, we can enter the `./xxx.patch/taskx/` directory and operate:

- patch-add.sh : apply the patch
- patch-reverse.sh: undo the patch

### Patch review file review.path

This file is a summary of all patch content, which is convenient for centralized reading and viewing.

## Other tools

### list.sh

When we use the tool in a new project, we can't formulate an accurate filter type at first, then we can continuously test and adjust through list.sh until the final filter configuration and task division are confirmed.

## Configuration file description

The configuration file consists of 3 layers of nested arrays, and each layer can be modified independently.

### patch task list

````
diff_tasks=(task1 task2 task3)
````

The content of this array is the number of patches we divide, or "patch tasks". Each task corresponds to an independent directory and generates an independent patch.

### patch task

This patch task includes two paths and three sets of filter configuration arrays. The first path is the path to the modified code, the second is the original code path. The content and position of the other three can be edited and changed at will, without affecting the final effect, which is a collection of them.

patch task config array format:

````
diff_task=(
 [new project full path]
 [old original project relative path]
 [system exclude array]
 [project exclude array]
 [user exclude array]
)
````

The content of the above three filter sets can be arbitrarily adjusted by users according to actual needs.

eg.:

````
task1=(
/home/a/dir1
./dir1
exclude_sys
exclude_proj
exclude_user
)
````

## todo

- When generating a patch, you can specify a configuration file
- Enrich other tools