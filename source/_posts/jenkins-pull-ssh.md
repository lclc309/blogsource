---
title: jenkins持续集成-自动部署
date: 2017-03-07
categories: 环境搭建
tags: 环境搭建
---

持续集成(Continuous integration)是一种软件开发实践,当项目越来越大,结构越来越复杂,人员越来越庞大.协同,编译,测试,发布都成为一种耗时间的事情.
持续集成是一种自动化的构建.将复杂繁琐的构建进行自动化.从而尽快地发现集成错误。许多团队发现这个过程可以大大减少集成的问题，让团队能够更快的开发内聚.

最近公司使用jenkins做持续集成.从git上获取代码,通过maven进行打包.
打包后进行发布到各自的服务器.

本文记录了如何进行部署到服务器的.

<!--more-->

# 前言
jenkins的安装,链接git什么的直接百度就ok了

# 安装插件
jenkins 自动部署需要一个插件 
`Publish Over SSH`

# 设置服务器信息
我们需要先设置要部署的服务器信息,即ssh信息

系统管理->系统设置 找到publish over ssh
![设置ssh](/img/jenkinspullssh/publish-ssh.png)

``` bash
Passphrase: 如果是密匙的话是密匙的密码,如果使用用户名登录,这里是用户名密码,没有密码留空

Path to key: 私钥的保存位置,我们把key拷贝到了jenkins工作目录下的sshkey/id_rsa.
		这一项可不写,可以直接把key的内容填到下面一栏中.两者可二选一.

Key : 私钥的内容.如果上面的没写的话,这里一定要写.和上面的选项是二选一的.也可以2个都给.

SSH Servers: 远程服务器相关配置,也就是我们要把程序发布到的那一台机器的相关配置.主要配置有

Name: 起一个名字,方便后面配置发布的时候,选择服务器.

Hostname: 远程服务器的IP地址,如果写远程的主机名的话,要在jenkins的hosts文件中加映射.

Username: 远程服务器的登录用户名

Remote Directory: 要把文件发布到远程机器的哪一个目录.

```

设置好点击保存

# 项目设置构建配置
jenkins中进入我们项目的面板,进入配置项.
找到Post Steps 面板,这个面板是说 在构建成功后执行的操作
添加一步操作,找到Send files or execute commands over SSH 一项,这一项是我们之前安装的 publish over ssh 插件所拥有的.
![添加操作](/img/jenkinspullssh/publish-ssh-3.png)

添加后:
![设置操作](/img/jenkinspullssh/publish-ssh-2.png)

```bash
sshServer 选择一个要发布的服务器,这里是前面已经添加好的服务器的名字.

source files: 要拷贝到远程的文件.这里的相对路径是相对于jenkins的WORKSPACE的.
	即jenkins的工作目录.

remove prefix: 这里是一个要注意的地方,如果这里的remove prefix为空,
	则jenkins会在远程服务器上面创建一个target的目录,然后把文件放进去.
	如果不想要target目录,这里就要写target.

remote directory: 把文件放在远程服务器的哪个位置.这个位置相对于之前设置的全局Remote Directory:

exec command: 把文件拷贝到远程服务器之后,要在远程服务器执行的命令,如果没有命令可以不写.
		我这里是让其执行一个文件,该文件内容为将tomcat重启.

```

# 其他
到上一步为止,所有的设置就结束了.
jenkins会在项目构建完成后,将打出的war包推到配置的服务器上.
这里贴出我wfmanager.sh的内容,以便参考.

```shell
#源地址
source_name="/storage/tools/data/wfmanager
/horizon-workflow-web/target/horizon-workflow-web.war"
#目标目录
target_dir="/storage/tools/horizon1"
#目标名称
target_name="workflow"

#1.首先关闭tomcat
PID=`ps aux | grep $target_dir | grep java | awk '{print $2}'`
if [ -n "$PID" ]; then
        echo "Will shutdown tomcat: $PID"
        sh "$target_dir/bin/shutdown.sh"
        sleep 5
fi
#1.1 停止失败,则直接kill进程

PID2=`ps aux | grep $target_dir | grep java | awk '{print $2}'`

if [ -n "$PID2" ]; then
		echo "shutdown tomcat has failed.Will kill tomcat: $PID"
        kill -9 $PID2
        
fi

#2. 删除掉原来的项目
#rm -rf ${target_dir}/webapps/${target_name}
rm  ${target_dir}/webapps/${target_name}.war

#3. 将文件移动到tomcat目录
mv ${source_name} ${target_dir}/webapps/${target_name}.war

#4. 启动tomcat
sh "$target_dir/bin/startup.sh"

#5. 验证tomcat启动成功
sleep 3

PID=`ps aux | grep $target_dir | grep java | awk '{print $2}'`
if [ -n "$PID" ]; then
        echo "\nRestart tomcat successfully!"
else
        echo "\nFail to startup tomcat"
        exit 1
fi

```



