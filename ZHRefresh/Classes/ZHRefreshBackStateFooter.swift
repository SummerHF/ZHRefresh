//  ZHRefreshBackStateFooter.swift
//  Refresh
//
//  Created by SummerHF on 09/05/2018.
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

/// 带有状态文字的上拉刷新控件
public class ZHRefreshBackStateFooter: ZHRefreshBackFooter {
    /// 文字距离圈圈, 箭头的距离
    public var lableLeftInset: CGFloat = 0.0
    private var _stateLbale: UILabel?
    private var stateTitles: [ZHRefreshState: String] = [ZHRefreshState: String]()
    /// 显示刷新状态的lable
    public var stateLable: UILabel! {
        if _stateLbale == nil {
           _stateLbale = UILabel.zh_lable()
           self.addSubview(_stateLbale!)
        }
        return _stateLbale
    }
    /// 设置state状态下的文字
    public func set(title: String, for state: ZHRefreshState) {
         self.stateTitles[state] = title
         self.stateLable.text = self.stateTitles[state]
    }

    /// 获取state状态下的的title
    public func titlelFor(state: ZHRefreshState) -> String? {
         return self.stateTitles[state]
    }

    // MARK: - override
    override public func prepare() {
        super.prepare()
        /// 初始化间剧
        self.lableLeftInset = ZHRefreshKeys.lableLeftInset
        /// 初始化文字
        self.set(title: Bundle.zh_localizedString(forKey: ZHRefreshKeys.backFooterIdleText), for: .idle)
        self.set(title: Bundle.zh_localizedString(forKey: ZHRefreshKeys.backFooterPullingText), for: .pulling)
        self.set(title: Bundle.zh_localizedString(forKey: ZHRefreshKeys.backFooterRefreshingText), for: .refreshing)
        self.set(title: Bundle.zh_localizedString(forKey: ZHRefreshKeys.backFooterNoMoreDataText), for: .nomoreData)

    }

    override public func placeSubViews() {
        super.placeSubViews()
        if self.stateLable.constraints.count > 0 { return }
        /// 状态标签
        self.stateLable.frame = self.bounds
    }

    override public var state: ZHRefreshState {
        get {
           return super.state
        }
        set {
            guard check(newState: newValue, oldState: state) != nil else { return }
            super.state = newValue
            self.stateLable.text = self.stateTitles[newValue]
        }
    }
}
