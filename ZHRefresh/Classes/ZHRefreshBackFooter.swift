//  ZHRefreshBackFooter.swift
//  Refresh
//
//  Created by SummerHF on 08/05/2018.
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

/// 会回弹到底部的上拉刷新控件
open class ZHRefreshBackFooter: ZHRefreshFooter {
    private var lastRefreshCount: Int = 0
    private var lastBottomDelta: CGFloat = 0.0

    // MARK: - 重写父类的方法
    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        self.scrollViewContentSizeDid(change: nil)
    }

    // MARK: - 实现父类的方法
    override open func scrollViewContentOffsetDid(change: [NSKeyValueChangeKey: Any]) {
        super.scrollViewContentOffsetDid(change: change)
        guard let indeedScrollView = self.scrollView else { return }
        /// 如果正在刷新 直接返回
        if self.state == .refreshing { return }
        _scrollViewOriginalInset = indeedScrollView.zh_inset
        /// 当前的contentOffSet
        let currentOffSetY = indeedScrollView.zh_offsetY
        /// 尾部控件刚好出现的offSetY
        let happenOffSetY = self.happenOffSetY()
        /// 如果是向下滚动到看不见尾部控件, 直接返回
        if  currentOffSetY <= happenOffSetY { return }
        let pullingPercent = (currentOffSetY - happenOffSetY) / self.zh_h
        /// 如果是全部加载完毕
        if self.state == .nomoreData {
            self.pullingPercent = pullingPercent
            return
        }
        if indeedScrollView.isDragging {
            self.pullingPercent = pullingPercent
            // 普通和即将刷新的临界点
            let normalPullingOffSetY = happenOffSetY + self.zh_h
            if self.state == .idle && currentOffSetY > normalPullingOffSetY {
                /// 转为即将刷新状态
                self.state = .pulling
            } else if self.state == .pulling && currentOffSetY <= normalPullingOffSetY {
                /// 转为普通状态
                self.state = .idle
            }
        } else if self.state == .pulling {
            /// 开始刷新
            self.beginRefreshing()
        } else if pullingPercent < 1 {
            self.pullingPercent = pullingPercent
        }
    }

    override open func scrollViewContentSizeDid(change: [NSKeyValueChangeKey: Any]?) {
        super.scrollViewContentSizeDid(change: change)
        guard let indeedScrollView = self.scrollView else { return }
        /// 内容高度
        let contentHeight = indeedScrollView.zh_contentH + self.ignoredScrollViewContentInsetBottom
        /// scrollView height
        let scrollHeight = indeedScrollView.zh_h - self.scrollViewOriginalInset.top - self.scrollViewOriginalInset.bottom + self.ignoredScrollViewContentInsetBottom
        self.zh_y = max(contentHeight, scrollHeight)
    }

    override open var state: ZHRefreshState {
        get {
           return super.state
        }
        set {
            guard let oldState = check(newState: newValue, oldState: state), let indeedScrollView = self.scrollView else { return }
            super.state = newValue
            if newValue == .nomoreData || state == .idle {
                /// 刷新完毕
                if oldState == .refreshing {
                    UIView.animate(withDuration: ZHRefreshKeys.slowAnimateDuration, animations: {
                        indeedScrollView.zh_insertB -= self.lastBottomDelta
                        if self.automaticallyChangeAlpha { self.alpha = 0.0 }
                    }) { (finished) in
                        self.pullingPercent = 0.0
                        if let endRefreshBlock = self.endRefreshingCompletionBlock {
                            endRefreshBlock()
                        }
                    }
                }
                let deltaH = self.heightForContentBreakView()
                /// 刚刷新完毕
                if oldState == .refreshing && deltaH > 0 && indeedScrollView.zh_totalCount() != self.lastRefreshCount {
                    let tempOffSetY = indeedScrollView.zh_offsetY
                    indeedScrollView.zh_offsetY = tempOffSetY
                }
            } else if newValue == .refreshing {
                /// 记录刷新前的数量
                self.lastRefreshCount = indeedScrollView.zh_totalCount()
                UIView.animate(withDuration: ZHRefreshKeys.fastAnimateDuration, animations: {
                    var bottom = self.zh_h + self.scrollViewOriginalInset.bottom
                    let deltaH = self.heightForContentBreakView()
                    /// 如果内容高度小于view的高度
                    if  deltaH < 0 {
                        bottom -= deltaH
                    }
                    self.lastBottomDelta = bottom - indeedScrollView.zh_insertB
                    indeedScrollView.zh_insertB = bottom
                    indeedScrollView.zh_offsetY = self.happenOffSetY() + self.zh_h
                }) { (finished) in
                    self.executeRefreshingCallBack()
                }
            }
        }
    }

    private func happenOffSetY() -> CGFloat {
        let deltaH = self.heightForContentBreakView()
        if  deltaH > 0 {
            /// 上拉加载更多的控件在可视区域内
            return deltaH - self.scrollViewOriginalInset.top
        } else {
            return -self.scrollViewOriginalInset.top
        }
    }

    /// 获得scrollView的内容超出view的高度
    private func heightForContentBreakView() -> CGFloat {
        if let indeedScrollView = self.scrollView {
           let height = indeedScrollView.frame.size.height - self.scrollViewOriginalInset.top - self.scrollViewOriginalInset.bottom
           return indeedScrollView.contentSize.height - height
        } else {
           return 0
        }
    }
}
