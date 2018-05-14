//  ZHRefreshFooter.swift
//  Refresh
//
//  Created by SummerHF on 02/05/2018.
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

/// 上拉加载更多
open class ZHRefreshFooter: ZHRefreshComponent {

    /// 忽略scrollView contentInset的bottom
    public var ignoredScrollViewContentInsetBottom: CGFloat = 0.0

    // MARK: - 构造方法

    /// 类方法, 创建footer
    static public func footerWithRefreshing(block: @escaping ZHRefreshComponentRefreshingBlock) -> ZHRefreshFooter {
        let footer = self.init()
        footer.refreshingBlock = block
        return footer
    }

    /// 带有回调target和action的footer
    static public func footerWithRefreshing(target: AnyObject, action: Selector) -> ZHRefreshFooter {
        let footer = self.init()
        footer.setRefreshing(target: target, action: action)
        return footer
    }

    // MARK: - override method

    override open func prepare() {
        super.prepare()
        /// 设置高度
        self.zh_h = ZHRefreshKeys.footerHeight
    }

    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        guard newSuperview != nil, let indeedScrollView = self.scrollView else { return }
        /// 监听scrollView的数据的变化
        if indeedScrollView.isKind(of: UITableView.self) || indeedScrollView.isKind(of: UICollectionView.self) {
            indeedScrollView.zh_reloadDataBlock = { totalCount in
                /// 预留属性
            }
        }
    }

    // MARK: - public method

    /// 提示没有更多数据
    public func endRefreshingWithNoMoreData() {
        DispatchQueue.main.async {
            self.state = .nomoreData
        }
    }

    /// 重置没有更多数据
    public func resetNoMoreData() {
        DispatchQueue.main.async {
            self.state = .idle
        }
    }
}
