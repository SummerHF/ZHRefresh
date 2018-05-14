//  ZHRefreshHeader.swift
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

/// 基础的下拉刷新控件, 负责监控用户下拉的状态
open class ZHRefreshHeader: ZHRefreshComponent {

    /// 插入的偏移量
    private var insertDelta: CGFloat = 0.0
    /// 这个Key用来存储上一次下拉刷新成功的时间
    var lastUpdatedTimeKey: String = ZHRefreshKeys.headerLastUpdatedTimeKey

    // MARK: - Set & Get

    /// 上一次下拉刷新成功的时间
    public var lastUpdatedTime: Date? {
        return UserDefaults.standard.object(forKey: self.lastUpdatedTimeKey) as? Date
    }

    /// 忽略多少scrollView的contentInset的top
    public var ignoredScrollViewContentInsetTop: CGFloat = 0.0 {
        didSet {
            self.zh_y = -self.zh_h - ignoredScrollViewContentInsetTop
        }
    }

    override open var state: ZHRefreshState {
        get {
            return super.state
        }
        set {
            /// check state, 相同的state 直接return
            guard let oldState = check(newState: newValue, oldState: state), let indeedScrollView = self.scrollView else { return }
            super.state = newValue
            /// 更具状态做事情
            if newValue == .idle {
                if oldState != .refreshing { return }
                /// save
                UserDefaults.standard.setValue(Date(), forKey: self.lastUpdatedTimeKey)
                UserDefaults.standard.synchronize()
                /// 恢复inset和offSet
                UIView.animate(withDuration: ZHRefreshKeys.slowAnimateDuration, animations: {
                    indeedScrollView.zh_insertT += self.insertDelta
                    /// 自动调整透明度
                    if self.automaticallyChangeAlpha { self.alpha = 0.0 }
                }) { (finished) in
                    self.pullingPercent = 0.0
                    /// 回调block
                    if let block = self.endRefreshingCompletionBlock {
                        block()
                    }
                }
            } else if newValue == .refreshing {
                DispatchQueue.main.async {
                    UIView.animate(withDuration: ZHRefreshKeys.fastAnimateDuration, animations: {
                        let top = self.scrollViewOriginalInset.top + self.zh_h
                        /// 增加滚动区域top
                        indeedScrollView.zh_insertT = top
                        /// 设置滚动位置
                        var offset = indeedScrollView.contentOffset
                        offset.y = -top
                        indeedScrollView.setContentOffset(offset, animated: false)
                    }) { (finished) in
                        /// 回调正在刷新的block
                        self.executeRefreshingCallBack()
                    }
                }
            }
        }
    }
    // MARK: - 构造方法

    /// 类方法, 快速的创建带有正在刷新回调的下拉刷新控件
    public static func headerWithRefreshing(block: @escaping ZHRefreshComponentRefreshingBlock) -> ZHRefreshHeader {
        let header = self.init()
        header.refreshingBlock = block
        return header
    }

    /// 类方法, 快速的创建下拉刷新控件
    public static func headerWithRefresing(target: AnyObject, action: Selector) -> ZHRefreshHeader {
        let header = self.init()
        header.setRefreshing(target: target, action: action)
        return header
    }

    // MARK: - 重写父类的方法

    override open func prepare() {
        super.prepare()
        self.zh_h =  ZHRefreshKeys.headerHeight
    }

    override open func placeSubViews() {
        super.placeSubViews()
        /// 设置y值(当自己的高度发生改变了, 肯定要重新调整y值, 所以放到placeSubViews中调整y值)
        self.zh_y = -self.zh_h - self.ignoredScrollViewContentInsetTop
    }
    
    override open func scrollViewContentOffsetDid(change: [NSKeyValueChangeKey: Any]) {
        super.scrollViewContentOffsetDid(change: change)
        guard let indeedScrollView = self.scrollView else { return }
        /// 在刷新的状态
        if self.state == .refreshing {
            /// 暂时保留
            /// 可能会导致问题
            if self.window == nil { return }
            /// sectionHeader停留解决, 计算应该偏移的位置 重点
            var inserT = -indeedScrollView.zh_offsetY > _scrollViewOriginalInset.top ? -indeedScrollView.zh_offsetY : _scrollViewOriginalInset.top
            inserT = inserT > self.zh_h + _scrollViewOriginalInset.top ? self.zh_h + _scrollViewOriginalInset.top : inserT
            indeedScrollView.zh_insertT = inserT
            self.insertDelta = _scrollViewOriginalInset.top - inserT
            return
        }
        /// 跳转到下一个控制器时, contentInset可能会变
        _scrollViewOriginalInset = indeedScrollView.zh_inset
        /// 当前的contentOffset
        let offsetY = indeedScrollView.zh_offsetY
        /// 头部控件刚好出现的offsetY
        let happenOffsetY = -self.scrollViewOriginalInset.top
        /// 如果向上滚动到看不见头部控件, 直接返回
        if  offsetY > happenOffsetY { return }
        /// 普通和即将刷新 的临界点
        /** 偏移量加上自身的高度 */
        let normalpullingOffsetY = happenOffsetY - self.zh_h
        let pullingPercent = (happenOffsetY - offsetY) / self.zh_h
        /// 如果正在拖拽
        if indeedScrollView.isDragging {
            self.pullingPercent = pullingPercent
            if self.state == .idle && offsetY < normalpullingOffsetY {
                /// 转换为即将刷新状态
                self.state = .pulling
            } else if self.state == .pulling && offsetY >= normalpullingOffsetY {
                /// 转换为普通状态
                self.state = .idle
            }
        } else if self.state == .pulling {
            /// 即将刷新 && 手松开
            self.beginRefreshing()
        } else if pullingPercent < 1 {
            self.pullingPercent = pullingPercent
        }
    }
}
