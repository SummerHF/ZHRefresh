<h1 align="center">ZHRefresh</h1>

<p align="center">
<a href="https://travis-ci.org/SummerHF/ZHRefresh"><img src="https://img.shields.io/travis/SummerHF/ZHNavigationController.svg?style=flat"></a>
<a href="https://cocoapods.org/pods/ZHRefresh"><img src="https://img.shields.io/cocoapods/v/ZHRefresh.svg?style=flat"></a>
<a><img src="https://img.shields.io/cocoapods/p/ZHNavigationController.svg?style=flat"></a>
<a href="https://cocoapods.org/pods/ZHRefresh"><img src="https://img.shields.io/badge/swift-4.0-orange.svg?style=flat"></a>
<a><img src="https://img.shields.io/github/license/mashape/apistatus.svg?style=flat"></a>
<a href="https://cocoapods.org/pods/ZHRefresh"><img src="https://img.shields.io/pypi/status/Django.svg"></a>
<a href="https://twitter.com/DefinetelyLoser"><img src="https://img.shields.io/badge/twitter-@SummerHF-blue.svg?style=flat"></a>
</p>

<p align="center"><strong>Swift</strong>版的刷新控件, <strong>MJRefresh</strong>的翻版</p>

## Contents

<strong>swift</strong>版的下拉刷新框架, 一行代码搞定<strong>上拉加载, 下拉刷新</strong>

* 开始使用
	* [Features 【支持哪些控件刷新】](#Features)
	* [Installation 【如何安装】](#Install)
	* [Class structure 【类结构】](#structure)
	
* 常见API
	* [ZHRefreshComponent.swift](#ZHRefreshComponent.swift)
	* [ZHRefreshHeader.swift](#ZHRefreshHeader.swift)
	* [ZHRefreshFooter.swift](#ZHRefreshFooter.swift)
	* [ZHRefresh.swift](#ZHRefresh.swift)
* 使用例子
	* [参考](#参考)
	* [下拉刷新(默认)](#the_drop_down_default)
	* [下拉刷新(动画图片)](#the_drop_down_animate)
	* [Features 【支持哪些控件刷新】](#Features)
	
----------
	
### <a id="Features"></a>支持哪些控件刷新
继承自<strong>UIScollView</strong>的类都可以使用.如
<strong>UIScrollView</strong>, <strong>UITableView</strong>, <strong>UICollectionView</strong>, <strong>WKWebView</strong>, <strong>UIWebView</strong>...

### <a id="Install"></a>如何安装
* 使用CocoaPods安装

因为该框架是基于<strong>swift</strong>的, 所以请确保打开<strong>use_frameworks!</strong>的注释, 允许使用动态库.

```
pod 'ZHRefresh'
```

然后

```
pod install
```

在需要使用该框架的地方

```
import ZHRefresh
```

即可

---------------

### <a id="structure"></a>类结构
![类结构](https://ws4.sinaimg.cn/large/006tNc79gy1frb7sduotwj313u0b7q3b.jpg)


## <a id="ZHRefreshComponent.swift"></a>ZHRefreshComponent.swift

```swift
    /// 正在刷新的回调
    public var refreshingBlock: ZHRefreshComponentRefreshingBlock?
    /// 开始刷新后的回调(进入刷新状态后的回调)
    public var beginRefreshingCompletionBlock: ZHRefreshComponentbeiginRefreshingCompletionBlock?
    /// 结束刷新的回调
    public var endRefreshingCompletionBlock: ZHRefreshComponentEndRefreshingCompletionBlock?
    /// 回调对象
    public weak var refreshTarget: AnyObject?
    /// 回调方法
    public var refreshAction: Selector?
    
```

## <a id="ZHRefreshHeader.swift"></a>ZHRefreshHeader.swift

```swift
    /// 类方法, 快速的创建下拉刷新控件
    public static func headerWithRefresing(target: AnyObject, action: Selector) -> ZHRefreshHeader
    /// 类方法, 快速的创建带有正在刷新回调的下拉刷新控件
    public static func headerWithRefreshing(block: @escaping ZHRefreshComponentRefreshingBlock) -> ZHRefreshHeader
    /// 忽略多少scrollView的contentInset的top
    public var ignoredScrollViewContentInsetTop: CGFloat = 0.0
    /// 上一次下拉刷新成功的时间
    public var lastUpdatedTime: Date?
```

## <a id="ZHRefreshFooter.swift"></a>ZHRefreshFooter.swift

```swift
	  /// 带有回调target和action的footer
    static public func footerWithRefreshing(target: AnyObject, action: Selector) -> ZHRefreshFooter
	  /// 类方法, 创建footer
     static public func footerWithRefreshing(block: @escaping ZHRefreshComponentRefreshingBlock) -> ZHRefreshFooter
    /// 提示没有更多数据
    public func endRefreshingWithNoMoreData()
    /// 重置没有更多数据
    public func resetNoMoreData()
```

## <a id="ZHRefresh.swift"></a>ZHRefresh.swift

```swift
   /// header and footer
	public extension UIScrollView {
    /// header
     @objc dynamic var header: ZHRefreshHeader? {
        get {
            return objc_getAssociatedObject(self, &ZHRefreshKeys.header) as? ZHRefreshHeader
        }
        set {
            if let newHeader = newValue {
                if let oldHeader = header {
                    /// 如果有旧值, 删除它
                    oldHeader.removeFromSuperview()
                }
                /// 添加新的
                self.insertSubview(newHeader, at: 0)
                /// 存储新值
                objc_setAssociatedObject(self, &ZHRefreshKeys.header, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
            }
        }
    }

    /// footer
     @objc dynamic var footer: ZHRefreshFooter? {
        get {
            return objc_getAssociatedObject(self, &ZHRefreshKeys.footer) as? ZHRefreshFooter
        }
        set {
            if let newFooter = newValue {
                if let oldFooter = footer {
                    /// 如果有旧值, 删除它
                    oldFooter.removeFromSuperview()
                }
                /// 添加新值
                self.insertSubview(newFooter, at: 0)
                /// 存储新值
                objc_setAssociatedObject(self, &ZHRefreshKeys.footer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
            }
        }
    }
}
```

## <a id="参考"></a>参考
请下载[源程序](https://github.com/SummerHF/ZHRefresh), 并打开附带的`demo`程序 `Example`->`ZHRefresh.xcworkspace`

* `MainViewController.swift` 主入口
* `CollectionViewController.swift` 提供`collectionView相关`的实例程序
* `TableViewController.swift`提供`tableView相关`的实例程序
* `WebViewController.swift`提供`webView相关`的实例程序
* `Example.swift`提供模型数据

具体结构如下图:
![](https://ws2.sinaimg.cn/large/006tNc79gy1frb8qg100wj30960a10sy.jpg)


以下截屏皆取自`iPhoneX`
## <a id="the_drop_down_default"></a>下拉刷新(默认)

code:
```swift
  // MARK: - 下拉刷新 默认样式

    @objc func action01() {
        /// 设置回调, 一旦进入刷新状态 就会调用block
        self.tableView.header = ZHRefreshNormalHeader.headerWithRefreshing { [weak self] in
            guard let `self` = self else { return }
            self.loadNewData()
        }
        /// 进入刷新状态
        self.tableView.header?.beginRefreshing()
    }
```
screenShots:
![](https://ws1.sinaimg.cn/large/006tNc79gy1frb9f0li9ng308k0ihgni.gif)

## <a id="the_drop_down_animate"></a>下拉刷新(动画图片)

code:
```swift
  // MARK: - 下拉刷新 动态图片

    @objc func action02() {
        /// 一旦进入刷新状态 就会调用target的action, 也就是调用self的loadNewData
        self.tableView.header = ZHRefreshChiBaoZiHeader.headerWithRefresing(target: self, action: #selector(loadNewData))
        self.tableView.header?.beginRefreshing()
    }
```
screenShots:
![](https://ws1.sinaimg.cn/large/006tNc79gy1frb9fyem4mg308k0ihgog.gif)


