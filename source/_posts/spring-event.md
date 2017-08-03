---
title: 使用spring事件机制
date: 2017-8-3
categories: spring
tags: spring
---

使用spring做事件


<!--more-->
#定义事件

``` java
public class DemoEvent extends ApplicationEvent {

	private static final long serialVersionUID = 1L;

	public DemoEvent(Object source) {
		super(source);
	}

}
```

所有的spring事件需要继承 ApplicationEvent 类，spring通过事件的类型来路由到事件监听器上。

#定义事件监听器

``` java
@Service
public class DemoEventListener implements ApplicationListener<DemoEvent> {

	@Override
	public void onApplicationEvent(DemoEvent event) {
		System.err.println("监听到新的时间聆听==============="+event.getSource());
	}

}
```

事件监听器需要实现ApplicationListener接口，泛型为监听的事件，并将监听器暴露至spring容器中。

#发布事件

只需要在事件发生时调用applicationContext中的方法


``` java
applicationContext.publishEvent(new DemoEvent("测试事件发生了"));
```

发布后为在同线程中进行监听

#异步监听

即发布事件与监听事件的处理不在同一个线程，进行异步的调用

需要在是application-context中加上配置

```xml

	<!-- 开启@AspectJ AOP代理 -->    
	<aop:aspectj-autoproxy proxy-target-class="true"/>    
	    
	<!-- 任务调度器 -->    
	<task:scheduler id="scheduler" pool-size="10"/>    
	    
	<!-- 任务执行器 -->    
	<task:executor id="executor" pool-size="10"/>    
	    
	<!--开启注解调度支持 @Async @Scheduled-->    
	<task:annotation-driven executor="executor" scheduler="scheduler" proxy-target-class="true"/>  

```

并在监听器上加上注解 @Async

``` java

@Service
public class DemoEventListener implements ApplicationListener<DemoEvent> {

	@Override
	@Async
	public void onApplicationEvent(DemoEvent event) {
		System.err.println("监听到新的时间聆听==============="+event.getSource());
	}

}

```
