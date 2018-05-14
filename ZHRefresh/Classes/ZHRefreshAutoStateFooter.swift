//  ZHRefreshAutoStateFooter.swift
//  Refresh
//
//  Created by SummerHF on 10/05/2018.
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
public class ZHRefreshAutoStateFooter: ZHRefreshAutoFooter {
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
    /// 隐藏刷新状态的文字
    public var refreshingTitleHidden: Bool = false
    /// 设置state状态下的文字
    public func set(title: String, for state: ZHRefreshState) {
        self.stateTitles[state] = title
        self.stateLable.text = self.stateTitles[state]
    }
    
    // MARK: - override
    
    override public func prepare() {
        super.prepare()
        /// 初始化间距
        self.lableLeftInset = ZHRefreshKeys.lableLeftInset
        self.set(title: Bundle.zh_localizedString(forKey: ZHRefreshKeys.autoFooterIdleText), for: .idle)
        self.set(title: Bundle.zh_localizedString(forKey: ZHRefreshKeys.autoFooterRefreshingText), for: .refreshing)
        self.set(title: Bundle.zh_localizedString(forKey: ZHRefreshKeys.autoFooterNoMoreDataText), for: .nomoreData)
        /// 监听lable
        self.stateLable.isUserInteractionEnabled = true
        self.stateLable.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(stateLableClick)))
    }
    
    @objc private func stateLableClick() {
        if self.state == .idle {
            self.beginRefreshing()
        }
    }
    
    override public func placeSubViews() {
        super.placeSubViews()
        if self.stateLable.constraints.count == 0 {
            /// 设置状态标签frame
            self.stateLable.frame = self.bounds
        }
    }
    
    override public var state: ZHRefreshState {
        /// 根据状态做事情
        get {
            return super.state
        }
        set {
            guard check(newState: newValue, oldState: state) != nil else { return }
            super.state = newValue
            if self.refreshingTitleHidden && newValue == .refreshing {
                self.stateLable.text = nil
            } else {
                self.stateLable.text = self.stateTitles[newValue]
            }
        }
    }
}
