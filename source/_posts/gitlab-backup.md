---
title: gitlab 定时自动备份
date: 2017-04-12 
categories: 环境搭建
tags: 环境搭建
---

公司版本控制工具从svn迁移至git后,需要每天进行备份.

<!-- more -->

gitlab路径:/storage/tools/gitlab

# 基本操作
备份的话使用命令

```shell
cd /storage/tools/gitlab
./use_gitlab
cd /storage/tools/gitlab/apps/gitlab/htdocs
bundle exec bin/rake gitlab:backup:create RAILS_ENV=production 
exit
```
备份的默认路径为:tmp/backups/
这里需要修改配置,使备份到指定路径

打开:/storage/tools/gitlab/apps/gitlab/htdocs/config/gitlab.yml文件


```yml
 ## Backup settings
  backup:
    path: "/var/opt/gitlab/backups"   # Relative paths are relative to Rails.root (default: tmp/backups/)
    archive_permissions:  # Permissions for the resulting backup.tar file (default: 0600)
    keep_time:    # default: 0 (forever) (in seconds)
    pg_schema:    # default: nil, it means that all schemas will be backed up
    upload:
      # Fog storage connection settings, see http://fog.io/storage/ .
      connection:
      # The remote 'directory' to store your backups. For S3, this would be the bucket name.
      remote_directory:
      multipart_chunk_size:
      encryption:
```

修改path路径:表示备份文件所在的路径
archive_permissions:备份文件所拥有的权限
keep_time:备份文件保留多长时间

# 脚本定时任务
使用命令的方式虽然可以进行备份,但第一比较复杂,第二需要人工敲不方便.
所以使用脚本的方法,然后用linux的定时任务去定时执行.

## 给出我的脚本:
gitlab_backup.sh

```shell
#做gitlab备份的脚本
#!/bin/bash 
if [ `id -u` -ne 0 ];then
   echo "this backup script must be exec as root." exit
fi
source_name="/storage/tools/gitlab"
date

PATH="${source_name}/nodejs/bin:${source_name}/apps/gitlabci/gitlabci-multirunner:${source_name}/apps/gitlab/gitlab-shell/bin:${source_name}/redis/bin:${source_name}/sqlite/bin:${source_name}/python/bin:${source_name}/perl/bin:${source_name}/git/bin:${source_name}/ruby/bin:${source_name}/mysql/bin:${source_name}/php/bin:${source_name}/postgresql/bin:${source_name}/go/bin:${source_name}/apache2/bin:${source_name}/common/bin:$PATH"

echo "backup gitlab to local storage begin.. " 
cd ${source_name}/apps/gitlab/htdocs

bundle exec bin/rake gitlab:backup:create RAILS_ENV=production

echo "this job is end."
```
主要还是使用之前命令执行,但是单纯的命令linux并不认识,所以在之前先指定一个环境变量PATH.

当然,现在是备份的本地,理论上应该是远程备份,执行完命令后可在脚本后使用rsync命令

## 定时任务
输入命令

```shell
crontab -e 
```
crontabl默认使用vim打开.
在打开的文件中添加一行

```shell
0 2 * * * /storage/tools/gitlab/gitlab_backup.sh
```
前面部分为cron表达式,分时日月周,后面为之前我们的脚本路径,此语句为每天凌晨2点执行一次


# 参考资料
[http://blog.chinaunix.net/uid-20682890-id-4698271.html](http://blog.chinaunix.net/uid-20682890-id-4698271.html)
[http://blog.csdn.net/felix_yujing/article/details/52918803](http://blog.csdn.net/felix_yujing/article/details/52918803)

