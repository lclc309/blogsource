# blogsource
个人博客的源码

# 常用命令
$ hexo g #完整命令为hexo generate，用于生成静态文件
$ hexo s #完整命令为hexo server，用于启动服务器，主要用来本地预览
$ hexo d #完整命令为hexo deploy，用于将本地文件发布到github上
$ hexo n #完整命令为hexo new，用于新建一篇文章

# 发布新文章

1.在Git Bash执行命令：$ hexo new "my new post"
2.在\source\_post中打开my-new-post.md，

title: my new post #可以改成中文的，如“新文章”
date: 2015-04-08 22:56:29 #发表日期，一般不改动
categories: blog #文章文类
tags: [博客，文章] #文章标签，多于一项时用这种格式，只有一项时使用tags: blog
---
#这里是正文，用markdown写，你可以选择写一段显示在首页的简介后，加上
<!--more-->#在<!--more-->之前的内容会显示在首页，之后的内容会被隐藏，当游客点击Read more才能看到。