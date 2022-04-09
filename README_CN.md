# patcher
一个一键生成补丁和自动化脚本的补丁工具集

## 特性
1. 支持复杂目录组合
2. 每个路径生成独立的补丁
3. 支持一键更新所有补丁和撤销所有补丁
4. 方便灵活的过滤类型配置（配置文件为bash格式的数组）

## 背景知识
### diff 命令参数
- r：递归，设置后diff会将两个不同版本源代码目录中的所有对应文件都进行一次比较，包括子目录文件
- N：确保补丁文件将正确地处理已经创建或删除文件的情况
- u：一体化diff输出
### patch 命令参数
- p Num：忽略几层文件夹，随后详解
- E：说明如果发现了空文件，那么就删除它
- R：取消打过的补丁

### patch相关命令
打补丁：patch -p1 < xxx.patch
取消补丁：patch -R -p1 < xxx.patch

## 补丁制作
1. 将`patcher`放到原工作的合适层次（所有修改的上层）
2. 修改`config.sh`,设置合适的过滤类型
3. 运行`differ.sh`
4. 补丁文件xxx.patch文件夹将生成在pather目录外层，和patcher目录并列

## 补丁使用
将`xxx.patch`目录放置到和生成补丁时相同的目录层次中
### 全量打补丁
```
./patch-add-all.sh
```

### 全量撤销补丁
```
./patch-reverse-all.sh
```

### 对每一个补丁单独操作
每一个补丁我们称之为一个patch task，需要单独操作和测试某一个补丁时，我们可以进入到 `./xxx.patch/taskx/`目录下，进行操作:
- patch-add.sh ：打补丁
- patch-reverse.sh：撤销补丁

### 补丁检视文件review.path
这个文件是汇总的所有补丁内容，方便集中性阅读检视。

## 其他工具
### list.sh
当我们在一个新项目中使用工具时，开始我们并无法制定准确的过滤类型，那么我们就可以通过list.sh来不断的测试和调整，直到确认出最终的过滤配置和task划分。

## 配置文件说明
配置文件由3层数组嵌套而成，每一层都可以独立修改。

### patch task list
```
diff_tasks=(task1 task2 task3)
```
这个数组内容就是我们划分的补丁数,或者叫"patch tasks"，每一个task对应一个独立的目录，生成一个独立的补丁。

### patch task
这个补丁任务中，包括两个路径和三组过滤配置数组。第一个路径是修改代码的路径，第二个是原始代码路径。其他三个的内容和位置都可以随意编辑和变动，不影响最终效果，最终效果都是他们的合集。

patch task config array format：
```
diff_task=(
 [new project full path]
 [old original project relative path]
 [system exclude array]
 [project exclude array]
 [user exclude array]
)
```
以上3个过滤集合的内容用户是可以根据实际需要，任意调整的。

eg.：
```
task1=(
/home/a/dir1
./dir1
exclude_sys 
exclude_proj 
exclude_user
)
```

## todo
- 生成补丁时，可以指定配置文件
- 丰富其他工具
