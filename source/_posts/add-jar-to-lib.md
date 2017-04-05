---
title: java动态加载jar文件
date: 2017-4-5
categories: java
tags: java
---

最近在对语言做国际化的支持.需求是这样的: 项目提供国际化支持,界面提供上传语言包的功能,上传语言包后直接在页面上切换语言就可以.
我们扩展了spring提供的ResourceBundleMessageSource进行加载国际化文件.

<!-- more -->

# 背景
ResourceBundleMessageSource 不需要进行主动的设置baseName(即国际化文件路径),他提供接口去指定某个baseName,我们利用这个特性直接
new ResourceBundleMessageSource();使用的时候则指定国际化文件路径.

将每种国际化文件放在不同的jar下,如英文的文件放在language_en.jar下.

默认的文件放在language下.

## 问题
但是我们遇到一个问题,就是并不是jar包上传到lib目录下,就直接启动了,因为并没有进行ClassLoad.

# 解决办法

上传文件后手动的进行动态加载此jar包.

```java
private void addJar(File file) {

    Method method = null;
    boolean accessible = false;
    try {
        method = URLClassLoader.class.getDeclaredMethod("addURL", URL.class);
        accessible = method.isAccessible(); // 获取方法的访问权限
        if (accessible == false) {
            method.setAccessible(true); // 设置方法的访问权限
        }
        // 获取系统类加载器
        URLClassLoader classLoader = (URLClassLoader) ClassLoader.getSystemClassLoader();
        URL url = file.toURI().toURL();
        method.invoke(classLoader, url);
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (method != null) {
            method.setAccessible(accessible);
        }
    }
}


```
思路即是调用URLClassLoader 的protected方法 addUrl 方法.
我们看看这个方法是做什么的.

```java 
  /**
     * Appends the specified URL to the list of URLs to search for
     * classes and resources.
     * <p>
     * If the URL specified is <code>null</code> or is already in the
     * list of URLs, or if this loader is closed, then invoking this
     * method has no effect.
     *
     * @param url the URL to be added to the search path of URLs
     */
    protected void addURL(URL url) {
        ucp.addURL(url);
    }

```
看注释是说:将指定的 URL 添加到 URL 列表中，以便搜索类和资源。如果URL是null或者URL已经被添加过了,则这个方法不会有任何的操作.



# 参考资料

[http://blog.csdn.net/mousebaby808/article/details/31788325](http://blog.csdn.net/mousebaby808/article/details/31788325)
[http://blog.csdn.net/u014470581/article/details/51355462](http://blog.csdn.net/u014470581/article/details/51355462)


