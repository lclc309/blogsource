---
title: springboot-静态资源文件处理(webjars)
date: 2017-03-10 
categories: spring-boot
tags: spring-boot
---

 本文主要借鉴了[Spring Boot 静态资源处理](http://blog.csdn.net/isea533/article/details/50412212)一文,作为记录使用.
 WebJars是将Web前端Javascript和CSS等资源打包成Java的Jar包，这样在Java Web开发中我们可以借助Maven这些依赖库的管理，保证这些Web资源版本唯一性。

 <!--more-->

# spring-boot静态文件处理
## 静态资源处理

spring Boot 默认的处理方式就已经足够了，默认情况下Spring Boot 使用WebMvcAutoConfiguration中配置的各种属性。

建议使用Spring Boot 默认处理方式，需要自己配置的地方可以通过配置文件修改。

但是如果你想完全控制Spring MVC，你可以在@Configuration注解的配置类上增加@EnableWebMvc，增加该注解以后WebMvcAutoConfiguration中配置就不会生效，你需要自己来配置需要的每一项。这种情况下的配置方法建议参考WebMvcAutoConfiguration类。

本文以下内容针对Spring Boot 默认的处理方式，部分配置通过在application.properties配置文件中设置。

## 配置资源映射
Spring Boot 默认配置的/**映射到/static（或/public ，/resources，/META-INF/resources)
/webjars/**会映射到classpath:/META-INF/resources/webjars/。

注意：上面的/static等目录都是在classpath:下面。
其查找顺序为

```bash
/META-INF/resources
/resources
/static
/public
```

那么,如果要增加自己查询的目录,即如果我们想自己的静态文件不放在这些目录里,需要进行设置.
继承WebMvcConfigurerAdapter 类 然后重写addResourceHandlers方法

```java
@Configurable
public class WebMvcConfiguration extends WebMvcConfigurerAdapter {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {

        registry.addResourceHandler("/mystatic/**")
        		.addResourceLocations("classpath:/mystatic/");
    }
}

```

这种方式会在默认的基础上增加/mystatic/**映射到classpath:/mystatic/，不会影响默认的方式，可以同时使用。

静态资源映射还有一个配置选项，为了简单这里用.properties方式书写：

```bash
spring.mvc.static-path-pattern=/** # Path pattern used for static resources.
```
这个配置会影响默认的/**，例如修改为/static/**后，只能映射如/static/js/sample.js这样的请求（修改前是/js/sample.js）。这个配置只能写一个值，不像大多数可以配置多个用逗号隔开的。

## 使用注意
例如有如下目录结构：

```bash
└─resources
    │  application.properties
    │
    ├─static
    │  ├─css
    │  │      index.css
    │  │
    │  └─js
    │          index.js
    │
    └─templates
            index.html
```
在index.html中该如何引用上面的静态资源呢？ 

```html
<link rel="stylesheet" type="text/css" href="/css/index.css">
<script type="text/javascript" src="/js/index.js"></script>
```
注意：默认配置的/**映射到/static（或/public ，/resources，/META-INF/resources）

当请求/css/index.css的时候，Spring MVC 会在/static/目录下面找到。

如果配置为/static/css/index.css，那么上面配置的几个目录下面都没有/static目录，因此会找不到资源文件！

**所以写静态资源位置的时候，不要带上映射的目录名（如/static/，/public/ ，/resources/，/META-INF/resources/)！**

# 使用WebJars
WebJars是将这些通用的Web前端资源打包成Java的Jar包，然后借助Maven工具对其管理，保证这些Web资源版本唯一性，升级也比较容易。关于webjars资源，有一个专门的网站http://www.webjars.org/，我们可以到这个网站上找到自己需要的资源，在自己的工程中添加入maven依赖，即可直接使用这些资源了

例如使用jQuery，添加依赖：

```xml
<dependency>
    <groupId>org.webjars</groupId>
    <artifactId>jquery</artifactId>
    <version>1.11.3</version>
</dependency>
```
然后可以如下使用：

```html
<script type="text/javascript" src="/webjars/jquery/1.11.3/jquery.js"></script>
```
webjars默认会将下的文件,放在/META-INF/resources/webjars/ 目录下,
所以spring-boot为我们做了重定向
在WebMvcAutoConfiguration类中:

```java
if (!registry.hasMappingForPattern("/webjars/**")) {
	customizeResourceHandlerRegistration(
			registry.addResourceHandler("/webjars/**")
					.addResourceLocations(
							"classpath:/META-INF/resources/webjars/")
			.setCachePeriod(cachePeriod));
}
```

你可能注意到href中的1.11.3版本号了，如果仅仅这么使用，那么当我们切换版本号的时候还要手动修改href，怪麻烦的，我们可以用如下方式解决。

先在pom.xml中添加依赖：

```xml
<dependency>
    <groupId>org.webjars</groupId>
    <artifactId>webjars-locator</artifactId>
</dependency>
```
增加一个WebJarController：

```java
@Controller
public class WebJarController {
    private final WebJarAssetLocator assetLocator = new WebJarAssetLocator();

    @ResponseBody
    @RequestMapping("/webjarslocator/{webjar}/**")
    public ResponseEntity locateWebjarAsset(@PathVariable String webjar, HttpServletRequest request) {
        try {
            String mvcPrefix = "/webjarslocator/" + webjar + "/";
            String mvcPath = (String) request.getAttribute(HandlerMapping.PATH_WITHIN_HANDLER_MAPPING_ATTRIBUTE);
            String fullPath = assetLocator.getFullPath(webjar, mvcPath.substring(mvcPrefix.length()));
            return new ResponseEntity(new ClassPathResource(fullPath), HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
    }
}
```
然后使用的时候按照如下方式：

```html
<script type="text/javascript" src="/webjarslocator/jquery/jquery.js"></script>
```

注意：这里不需要在写版本号了，但是注意写url的时候，只是在原来url基础上去掉了版本号，其他的都不能少！


# 參考資料
[http://blog.csdn.net/isea533/article/details/50412212](http://blog.csdn.net/isea533/article/details/50412212)
[http://www.cnblogs.com/mingziday/p/4748534.html](http://www.cnblogs.com/mingziday/p/4748534.html)
