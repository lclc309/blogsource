# blogsource
个人博客的源码

# 常用命令
$ hexo g #完整命令为hexo generate，用于生成静态文件
$ hexo s #完整命令为hexo server，用于启动服务器，主要用来本地预览
$ hexo d #完整命令为hexo deploy，用于将本地文件发布到github上
$ hexo n #完整命令为hexo new，用于新建一篇文章

# 建议安装的插件
npm install hexo-generator-index --save
npm install hexo-generator-archive --save
npm install hexo-generator-category --save
npm install hexo-generator-tag --save
npm install hexo-server --save
npm install hexo-deployer-git --save
npm install hexo-deployer-heroku --save
npm install hexo-deployer-rsync --save
npm install hexo-deployer-openshift --save
npm install hexo-renderer-marked@0.2 --save
npm install hexo-renderer-stylus@0.2 --save
npm install hexo-generator-feed@1 --save
npm install hexo-generator-sitemap@1 --save

# 设置页面
### 添加标签tags页面
>  `$ cd hexo目录`
>  `$ hexo new page tags`

内容如下所示，如果要关闭tags页面的评论可以设置comments为false：

> `title: 标签`
 `date: 2014-12-22 12:39:04`
 `type: "tags"`
 `comments: false`
 `---`

这样以后tags页面在每次执行hexo generate后自动更新。

### 添加分类页面
和上面的一样，在hexo目录下执行下面命令：
>  `$ hexo new page categories`

内容为：
> `title: 分类`
> `date: 2014-12-22 12:39:04`
> `type: "categories"`
> `comments: false`
> `---`

### 多说评论
登录多说官网，登录后点我要安装，然后填写站点相关信息，最主要的是duoshuo_shortname这个字段，设置后之后修改themes\next_config.yml文件，把duoshuo_shortname改成你的，如下所示：

> duoshuo_shortname: ezlippi

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