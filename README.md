<h1 align="center">ZHRefresh</h1>

<p align="center">
<a href="https://travis-ci.org/SummerHF/ZHRefresh"><img src="https://img.shields.io/travis/SummerHF/ZHNavigationController.svg?style=flat"></a>
<a href="https://cocoapods.org/pods/ZHRefresh"><img src="https://img.shields.io/cocoapods/v/ZHNavigationController.svg?style=flat"></a>
<a><img src="https://img.shields.io/cocoapods/p/ZHNavigationController.svg?style=flat"></a>
<a><img src="https://img.shields.io/github/license/mashape/apistatus.svg?style=flat"></a>
<a href="https://cocoapods.org/pods/ZHRefresh"><img src="https://img.shields.io/badge/swift-4.0-orange.svg?style=flat"></a>
</p>

<p align="center"><strong>swift</strong>版本刷新控件,可根据自己的需求自行定制样式</p>

## Contents

* [Getting Started 【开始使用】](#Getting_Started)
	* [Features 【能做什么】](#Features)
	* [Thinking 【实现思路】](#Thinking)
	
	
### <a id="Getting_Started"></a>Getting Started【开始使用】

#### <a id="Features"></a>Features 【能做什么】

* 为每一个控制器定制`navigationBar`
* 为每一个控制器添加`全屏侧滑返回手势`,或者`使用系统的左侧侧滑返回手势`等
* 单独的禁用某一个页面的`侧滑返回手势`
* 禁用全局页面的`侧滑返回手势`
* 提供多种类型的侧滑返回交互动画效果
* 支持`3D Touch`
* `hidesBottomBarWhenPushed`可选显示或隐藏指定页面(默认全部隐藏)


Gesture(手势相关) | Function(功能) | 支持(enable) | 不支持(disable)
--------- | -------------|------------|----------
 禁用手势 |  禁用全局手势 | 支持 | - 
 禁用手势 |  禁用单个页面手势 | 支持 | -
 半屏侧滑 |  屏幕左侧边缘右滑`Pop` | 支持自定义样式，支持精度设置|不支持侧滑样式选择(默认使用自定义样式),不支持左滑`Push`
 全屏侧滑 |  屏幕右滑`Pop`,左滑`Push`| 支持自定义样式,支持侧滑样式选择(默认使用自定义样式),支持左滑`Push`(可选)|不支持精度设置.


#### <a id="Thinking"></a>Features 【实现思路】
大致的需要实现的效果如下

<p align="center"><img src = "https://ws3.sinaimg.cn/large/006tKfTcgy1fpkifxs2j3g308w0fskjl.gif"></p>
<p align="center">网易新闻</p>

<p align="center"><img src = "https://ws3.sinaimg.cn/large/006tKfTcgy1fpkiqyg9sxg30820ehn3b.gif"></p>
<p align="center">今日头条</p>

我们知道,为了满足多样化的`navigation bar`需求,仅仅在控制器中修改`navigation bar`的属性是很难达到上图效果的.因为多个控制器是共用同一个导航条的(同一个栈中的控制器).那么我们该怎么实现上述的效果,大致有三种实现思路:

```

1. 第一种是使用自定义navigationBar.淘宝,网易新闻,等使用的是这种.
2. 第二种是用截图的办法,在push到下一个页面时,截取屏幕,在使用edgePan来pop时看到的就是背后的截图,也能实现这种效果.京东,天猫等使用的是这种.
3. 第三种是使用了一种比较特别,比较巧妙的办法实现的,为每一个控制器拥有自己独立的导航栏

```
具体的思路可参考[Jerry Tian's Blog](http://jerrytian.com/2016/01/07/%E7%94%A8Reveal%E5%88%86%E6%9E%90%E7%BD%91%E6%98%93%E4%BA%91%E9%9F%B3%E4%B9%90%E7%9A%84%E5%AF%BC%E8%88%AA%E6%8E%A7%E5%88%B6%E5%99%A8%E5%88%87%E6%8D%A2%E6%95%88%E6%9E%9C/).该框架借鉴的是第三种思路.采用导航控制器包裹的方式在填充到容器视图中,并将该容器视图作为我们导航控制器的根视图控制器,在每次push的时候,都采用上述包裹的方式.

<p align="center"><img src = "https://ws2.sinaimg.cn/large/006tKfTcly1fpkjj650izj30cv0623ym.jpg"></p>
<p align="center">结构图</p>

其中灰色区域的控制器就是你自己的控制器.











