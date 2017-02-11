---
title: 使用hexo+github做自己的个人博客
date: 2017-2-10
categories: 环境搭建
tags: 环境搭建
---


作为一名程序员,乐于分享是一项传统美德,本人也是经常会逛一些论坛,网站,自己也写过一些博客,后来技术网站越来越多,眼花缭乱,便想做一个自己的博客.
本文便记录了自己是如何基于github pages来做自己的博客的.

<!--more-->

# github pages介绍
github是一个代码托管的工具,而github pages提供一个服务,当你的github repository 被命名为yourname.github.io时,	那么他的master分支上的文件则提供在yourname.github.io的跟目录访问.
如果此时我们的文件是html文件的话,就相当于一个服务器了.
我们就是利用这个特性来做自己的博客.
整体思路为:将们的博客生成静态页面放到github pages上.

那么纯用html文件来写博客也是一种痛苦的事情.尤其是对我们这种后端程序员,前端能力毕竟有限,还要我们有markdown,而markdown也几乎成为了一种写博客文章的主流工具.
为了能使我们的博客更加美观一些,选择了hexo模板工具,该工具提供了一种生成静态文件的方法,能有效的使用网站模板来美化静态页面.

# 申请github pages
申请github pages完成参考官方文档就可以了.
具体参考[官方文档](https://pages.github.com/ "GitHub Pages")

# 安装git和nodejs
因为我是window系统，对于git和nodejs的安装直接下一步就行了
git： [git官网](https://git-scm.com/download/)
nodejs:[nodejs官网](https://nodejs.org/en/)
安装之后进行验证：
打开cmd

``` bash
git --version
node -v
npm -v
```
![测试](/img/hexo20150701016.png)

# 安装hexo
hexo是基于node.js的静态博客，官网也是搭建在GitHub上
在电脑上新建一个文件夹，比如取名为test，该文件夹用于存放你的博客源码
>注意：博客源码并不是博客，而是一种模板，hexo会通过此模板进行生成静态博客，建议将博客源码也提交到github上，方便保存。

## 安装淘宝镜像
安装hexo有可能会出现被墙掉的情况，这里使用淘宝的NPM镜像。
在test文件里打开git bash。

>`npm install -g cnpm --registry=https://registry.npm.taobao.org`

## 安装hexo
使用cnpm命令，安装hexo
>`cnpm install -g hexo-cli`

继续输入命令：
>`cnpm install hexo --save`

安装完成后，验证是否安装正确
>`hexo -v`

# 运行hexo
## 初始化hexo
>`hexo init`
## 安装生成器
>`cnpm install`
## 运行hexo
>` hexo s -g`

打开浏览器，查看是否成功
>`http://localhost:4000`

# hexo 与github pages 结合

## 连接github pages
我们进入test这个文件夹，发现里面已经有了一些文件
![预览](/img/hexo20170211162714.png)
其中_config.yml 是hexo的配置文件，我们姑且叫外置配置文件（因为不少模板有自己的内置配置文件）
打开_config.yml进行配置，注意:key和value之间必须有一个空格

```bash
title: 博客主题目
subtitle: 博客副题目
description: 博客的描述
author: 博客的作者
language: zh-Hans
timezone: Asia/Shanghai

# URL 网址
## 如果您的网站存放在子目录中，例如 http://yoursite.com/blog，则请将您的 url 设为 http://yoursite.com/blog 并把 root 设为 /blog/。
url: http://tengj.github.io
root: /
permalink: :year/:month/:day/:title/
permalink_defaults:

# Directory 目录配置
source_dir: source     #源文件夹，这个文件夹用来存放内容。
public_dir: public     #公共文件夹，这个文件夹用于存放生成的站点文件。
tag_dir: tags         #标签文件夹
archive_dir: archives     #归档文件夹
category_dir: categories #分类文件夹
code_dir: downloads/code #nclude code 文件夹
i18n_dir: :lang         #国际化（i18n）文件夹
skip_render:         #跳过指定文件的渲染，您可使用 glob 表达式来匹配路径。

# Writing 文章
new_post_name: :title.md # 新建文章默认文件名
default_layout: post     # 默认布局
titlecase: false # Transform title into titlecase
external_link: true # 在新标签中打开一个外部链接，默认为true
filename_case: 0    #转换文件名，1代表小写；2代表大写；默认为0，意思就是创建文章的时候，是否自动帮你转换文件名，默认就行，意义不大。
render_drafts: false  #是否渲染_drafts目录下的文章，默认为false
post_asset_folder: false #启动 Asset 文件夹
relative_link: false    #把链接改为与根目录的相对位址，默认false
future: true        #显示未来的文章，默认false
highlight:    #代码块的设置
  enable: true
  line_number: true
  auto_detect: false
  tab_replace:

# Category & Tag 分类和标签的设置
default_category: uncategorized        #默认分类
category_map:                #分类别名
tag_map:                #标签别名

# Date / Time format
## Hexo uses Moment.js to parse and display date
## You can customize the date format as defined in
## http://momentjs.com/docs/#/displaying/format/
date_format: YYYY-MM-DD
time_format: HH:mm:ss

# Pagination 分页
## Set per_page to 0 to disable pagination
per_page: 10    #每页显示的文章量 (0 = 关闭分页功能)
pagination_dir: page    #分页目录

#博客主题，即本博客网站使用的模板，可在https://github.com/hexojs/hexo/wiki/Themes上选择
theme: next

# Deployment
## Docs: https://hexo.io/docs/deployment.html

#链接的git地址
deploy:
  type: git
  repository: git@github.com:yourname/yourname.github.io.git
  branch: master

```

主要是deploy属性，进行设置为你之前申请的github pages的git地址

# 写博客

## 新建博客
使用命令新建博客
>`hexo new "hello"`

在文件夹/test/source/_posts/ 里找到hello.md，此文件即是你的博客的主体内容。
此文件开头需要有一定的格式
```bash
---
title: hello
date: 2015-07-01 22:37:23
categories:
  - 日志
  - 二级目录
tags:
  - hello
---

摘要:
<!--more-->
正文:

```

## 发布博客
设置deploy属性后，进行通过命令进行发布
*先安装插件
>`npm install hexo-deployer-git --save`

*发布博客
> `hexo d -g`

*发布成功后可以直接访问 http：//yourname.github.io进行查看你新生成的博客

## git 的keygen
当进行发布的时候，会发现没有git的权限，这是因为没有用户名密码造成的，我们不用用户名密码，而是使用keygen的方式

*生成keygen
>`ssh-keygen -t rsa -C '邮件地址@youremail.com'`

一路回车
```bash
    1、打开本地C:\Users\Administrator\.ssh\id_rsa.pub文件。此文件里面内容为刚才生成人密钥。如果看不到这个文件，你需要设置显示隐藏文件。准确的复制这个文件的内容，才能保证设置的成功。

    2、登陆github系统。点击右上角的 Account Settings—>SSH Public keys —> add another public keys

    3、把你本地生成的密钥复制到里面（key文本框中）， 点击 add key 就ok了

```

# 参考资料

[http://blog.csdn.net/jzooo/article/details/46781805](http://blog.csdn.net/jzooo/article/details/46781805)
[http://www.cnfeat.com/blog/2014/05/10/how-to-build-a-blog/](http://www.cnfeat.com/blog/2014/05/10/how-to-build-a-blog/)
[http://www.ezlippi.com/blog/2016/02/jekyll-to-hexo.html](http://www.ezlippi.com/blog/2016/02/jekyll-to-hexo.html)
[https://hexo.io/zh-cn/docs/](https://hexo.io/zh-cn/docs/)