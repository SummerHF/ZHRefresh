//  ZHRefreshComponent.swift
//  Refresh
//
//  Created by SummerHF on 27/04/2018.
//
//
//  Copyright (c) 2018 SummerHF(https://github.com/summerhf)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit

/// 刷新控件的状态
public enum ZHRefreshState {
    /**普通闲置状态*/
    case idle
    /**松开就可以进行刷新的状态*/
    case pulling
    /**正在刷新中的状态*/
    case refreshing
    /**即将刷新的状态*/
    case willRefresh
    /**所有数据加载完毕, 没有更多的数据了*/
    case nomoreData
    /**初始状态 刚创建的时候 状态会从none--->idle*/
    case none
}

/// 正在刷新的回调
public typealias ZHRefreshComponentRefreshingBlock = () -> Void
/// 开始刷新后的回调(进入刷新状态后的回调)
public typealias ZHRefreshComponentbeiginRefreshingCompletionBlock = () -> Void
/// 结束刷新后的回调
public typealias ZHRefreshComponentEndRefreshingCompletionBlock = () -> Void

/// 刷新控件的基类
open class ZHRefreshComponent: UIView {
    /// 记录scrollView刚开始的inset
    var _scrollViewOriginalInset: UIEdgeInsets = UIEdgeInsets.zero
    /// 父控件
    private weak var _scrollView: UIScrollView? {
        didSet {
            /// 初始化状态
            self.state = .idle
        }
    }
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
    /// 手势
    var pan: UIPanGestureRecognizer?

    // MARK: - Set & Get 交给子类去访问

    /// 记录scrollView刚开始的inset, 只读属性
    public var scrollViewOriginalInset: UIEdgeInsets {
        return _scrollViewOriginalInset
    }
    /// 父控件
    public var scrollView: UIScrollView? {
        return _scrollView
    }

    /// 拉拽的百分比(交给子类重写)
    open var pullingPercent: CGFloat = 0.0 {
        didSet {
            if self.isRefreshing() { return }
            if self.automaticallyChangeAlpha {
                self.alpha = pullingPercent
            }
        }
    }

    /// 根据拖拽比例自动切换透明度, 默认是false
    public var automaticallyChangeAlpha: Bool = false {
        didSet {
            if self.isRefreshing() { return }
            if automaticallyChangeAlpha {
                self.alpha = self.pullingPercent
            } else {
                self.alpha = 1.0
            }
        }
    }

    /// 内部维护的状态
    private var _state: ZHRefreshState = .none
    /// 刷新状态, 一般交给子类内部实现, 默认是普通状态 (通过该方式模拟oc的set and get)
    open var state: ZHRefreshState {
        get {
            return _state
        }
        set {
            _state = newValue
            /// 加入主队列的目的是等setState: 方法调用完毕后, 设置完文字后再去布局子控件
            DispatchQueue.main.async {
            self.setNeedsLayout()
            }
        }
    }

    /// 设置回调对象和回调方法
    public func setRefreshing(target: AnyObject, action: Selector) {
        self.refreshTarget = target
        self.refreshAction = action
    }

    /// 触发回调(交给子类去处理)
    public func executeRefreshingCallBack() {
        DispatchQueue.main.async {
            /// 回调方法
            if let refreshBlock = self.refreshingBlock {
                refreshBlock()
            }
            if let target = self.refreshTarget, let action = self.refreshAction {
                if ZHRefreshRuntime.target(target, canPerform: action) {
                    ZHRefreshRuntime.target(target, perform: action, view: self)
                }
            }
            if let beginRefreshBlock = self.beginRefreshingCompletionBlock {
                beginRefreshBlock()
            }
        }
    }

    // MARK: - 刷新状态控制

    /// 进入刷新状态
    public func beginRefreshing() {
        UIView.animate(withDuration: ZHRefreshKeys.fastAnimateDuration) {
            self.alpha = 1.0
        }
        self.pullingPercent = 1.0
        /// 只要正在刷新, 就完全显示
        if self.window != nil {
            self.state = .refreshing
        } else {
            self.state = .willRefresh
            /// 预防从另一个控制器回到这个控制器的情况, 回来要重新刷一下
            self.setNeedsDisplay()
        }
    }

    public func beginRefreshingWithCompletionBlock(completionBlock: @escaping () -> Void) {
        self.beginRefreshingCompletionBlock = completionBlock
        self.beginRefreshing()
    }

    /// 结束刷新状态
    public func endRefreshing() {
        DispatchQueue.main.async {
            self.state = .idle
        }
    }

    public func endRefreshingWithCompletionBlock(completionBlock: @escaping () -> Void) {
        self.endRefreshingCompletionBlock = completionBlock
        self.endRefreshing()
    }

    /// 是否正在刷新
    public func isRefreshing() -> Bool {
        return self.state == .refreshing || self.state == .willRefresh
    }

    // MARK: - 初始化

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        /// 准备工作
        self.prepare()
    }

    override open func layoutSubviews() {
        self.placeSubViews()
        super.layoutSubviews()
    }

    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        guard let superView = newSuperview else { return }
        /// 如果不是UIScrollView, 不做任何事情
        if !superView.isKind(of: UIScrollView.self) { return }
        /// 旧的父控件移除监听
        self.removeObservers()
        /// 记录scrollView
        if let scrollView = superView as? UIScrollView {
            /// 新的父控件
            /// 宽度
            self.zh_w = superView.zh_w
            /// 位置
            self.zh_x = 0
            _scrollView = scrollView
            /// 设置永远支持垂直弹簧效果 否则不会出发UIScrollViewDelegate的方法, KVO也会失效
            _scrollView?.alwaysBounceVertical = true
            /// 记录UIScrollView最开始的contentInset
            _scrollViewOriginalInset = scrollView.contentInset
            /// 添加监听
            self.addObservers()
        }
    }

    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        if self.state == .willRefresh {
            /// 预防view还未完全显示就调用了beginRefreshing ?????
            /// FIXME: WHY?
            self.state = .refreshing
        }
    }

    // MARK: - 交给子类们去实现

    /// 初始化
    open func prepare() {
        /// 基本属性
        self.autoresizingMask = [.flexibleWidth]
        self.backgroundColor = UIColor.clear
    }

    /// 摆放子控件的frame
    open func placeSubViews() {}
    /// 当scrollView的contentOffset发生改变的时候调用
    open func scrollViewContentOffsetDid(change: [NSKeyValueChangeKey: Any]) {}
    /// 当scrollView的contentSize发生改变的时候调用
    open func scrollViewContentSizeDid(change: [NSKeyValueChangeKey: Any]?) {}
    /// 当scrollView的拖拽状态发生改变的时候调用
    open func scrollViewPanStateDid(change: [NSKeyValueChangeKey: Any]) {}

    // MARK: - Observers

    /// 添加监听
    func addObservers() {
        let options: NSKeyValueObservingOptions = [NSKeyValueObservingOptions.new, NSKeyValueObservingOptions.old]
        self.scrollView?.addObserver(self, forKeyPath: ZHRefreshKeys.contentOffset, options: options, context: nil)
        self.scrollView?.addObserver(self, forKeyPath: ZHRefreshKeys.contentSize, options: options, context: nil)
        self.pan = self.scrollView?.panGestureRecognizer
        self.pan?.addObserver(self, forKeyPath: ZHRefreshKeys.panState, options: options, context: nil)
    }

    /// 移除监听
    func removeObservers() {
        self.superview?.removeObserver(self, forKeyPath: ZHRefreshKeys.contentOffset)
        self.superview?.removeObserver(self, forKeyPath: ZHRefreshKeys.contentSize)
        self.pan?.removeObserver(self, forKeyPath: ZHRefreshKeys.panState)
        self.pan = nil
    }

    /// KVO
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if !self.isUserInteractionEnabled || self.isHidden { return }
        guard let path = keyPath as NSString? else { return }
        /// 未开启手势交互 或者被隐藏 直接返回
        if let chanage = change, path.isEqual(to: ZHRefreshKeys.contentSize) {
            self.scrollViewContentSizeDid(change: chanage)
        } else if let change = change, path.isEqual(to: ZHRefreshKeys.contentOffset) {
            self.scrollViewContentOffsetDid(change: change)
        } else if let change = change, path.isEqual(to: ZHRefreshKeys.panState) {
            self.scrollViewPanStateDid(change: change)
        }
    }

    /// 检测状态

    /// - parameter newState: 新状态
    /// - parameter oldState: 旧状态

    /// - return: 如果两者相同 返回nil, 如果两者不相同, 返回旧的状态
    public func check(newState: ZHRefreshState, oldState: ZHRefreshState) -> ZHRefreshState? {
         return newState == oldState ? nil : oldState
    }
}
