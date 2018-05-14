//  ZHRefreshStateHeader.swift
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

public typealias lastUpdatedTimeTextBlock = (Date) -> String

/// 带有状态文字的下拉刷新控件
public class ZHRefreshStateHeader: ZHRefreshHeader {

    // MARK: - 刷新时间相关
    
    public var lastUpdatedTimeTextBlcok: lastUpdatedTimeTextBlock?

    private var _lastUpdatedTimeLable: UILabel?
    /// 显示上一次刷新时间的lable
    public var lastUpdatedTimeLable: UILabel! {
        if _lastUpdatedTimeLable == nil {
           _lastUpdatedTimeLable = UILabel.zh_lable()
           self.addSubview(_lastUpdatedTimeLable!)
        }
        return _lastUpdatedTimeLable
    }

    /// 显示刷新状态的lable
    private var _stateLable: UILabel?
    public var stateLable: UILabel! {
        if _stateLable == nil {
           _stateLable = UILabel.zh_lable()
           self.addSubview(_stateLable!)
        }
        return _stateLable
    }

    // MARK: - 状态相关

    /// 文字距离圈圈, 箭头的距离
    public var lableLeftInset: CGFloat = 0.0
    /// 所有状态对应的文字
    private var stateTitles: [ZHRefreshState: String] = [ZHRefreshState: String]()

    /// 设置state状态下的文字
    public func set(title: String?, for state: ZHRefreshState) {
         if title == nil { return }
         self.stateTitles[state] = title
         self.stateLable.text = self.stateTitles[state]
    }

    // MARK: - Key的处理

    override public var lastUpdatedTimeKey: String {
        didSet {
            super.lastUpdatedTimeKey = lastUpdatedTimeKey
            if self.lastUpdatedTimeLable.isHidden { return }
            if let time = self.lastUpdatedTime {
                 /// 如果有block， 回调blcok并且return
                if let lastUpdatedTextBlock = self.lastUpdatedTimeTextBlcok {
                   self.lastUpdatedTimeLable.text = lastUpdatedTextBlock(time)
                   return
                }
                let calendar = currentCalendar()
                /// 存储的时间
                let cmp1 = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: time)
                /// 当前时间
                let cmp2 = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: Date())
                /// 格式化日期
                let formatter = DateFormatter()
                var isToday = false
                /// 今天
                if cmp1.day == cmp2.day {
                    formatter.dateFormat = " HH:mm"
                    isToday = true
                } else if cmp1.year == cmp2.year {
                    /// 今年
                    formatter.dateFormat = "MM-dd HH:mm"
                } else {
                    formatter.dateFormat = "yyyy-MM-dd HH:mm"
                }
                let timeStr = formatter.string(from: time)
                /// 显示日期
                let desc: String = isToday ? Bundle.zh_localizedString(forKey: ZHRefreshKeys.headerDateTodayText) : ""
                self.lastUpdatedTimeLable.text = String(format: "%@%@%@", arguments: [Bundle.zh_localizedString(forKey: ZHRefreshKeys.headerLastTimeText), desc, timeStr])
            } else {
                self.lastUpdatedTimeLable.text = String(format: "%@%@", arguments: [Bundle.zh_localizedString(forKey: ZHRefreshKeys.headerLastTimeText), Bundle.zh_localizedString(forKey: ZHRefreshKeys.headerNoneLastDateText)])
            }
        }
    }

    // MARK: - 日历获取方法

    private func currentCalendar() -> Calendar {
        return Calendar.current
    }

    // MARK: - 重写父类的方法

    override public func prepare() {
        super.prepare()
        self.lableLeftInset = ZHRefreshKeys.lableLeftInset
        self.set(title: Bundle.zh_localizedString(forKey: ZHRefreshKeys.headerIdleText), for: .idle)
        self.set(title: Bundle.zh_localizedString(forKey: ZHRefreshKeys.headerPullingText), for: .pulling)
        self.set(title: Bundle.zh_localizedString(forKey: ZHRefreshKeys.headerRefreshingText), for: .refreshing)
    }

    override public func placeSubViews() {
        super.placeSubViews()
        if self.stateLable.isHidden { return }
        let noConstraintOnStatusLable: Bool = self.stateLable.constraints.count == 0
        if self.lastUpdatedTimeLable.isHidden {
            /// 状态
            if noConstraintOnStatusLable {
                self.stateLable.frame = self.bounds
            }
        } else {
            let stateLableH: CGFloat  = self.zh_h * 0.5
            /// 状态
            if noConstraintOnStatusLable {
                self.stateLable.zh_x = 0
                self.stateLable.zh_y = 0
                self.stateLable.zh_w = self.zh_w
                self.stateLable.zh_h = stateLableH
            }
            /// 更新时间
            if self.lastUpdatedTimeLable.constraints.count == 0 {
                self.lastUpdatedTimeLable.zh_x = 0
                self.lastUpdatedTimeLable.zh_y = stateLableH
                self.lastUpdatedTimeLable.zh_w = self.zh_w
                self.lastUpdatedTimeLable.zh_h = self.zh_h - stateLableH
            }
        }
    }

    override public var state: ZHRefreshState {
        /// check date
        get {
           return super.state
        }
        set {
            guard check(newState: newValue, oldState: state) != nil else { return }
            super.state = newValue
            /// 设置状态文字
            self.stateLable.text = self.stateTitles[newValue]
            /// 重新设置key(重新显示时间)
            self.lastUpdatedTimeKey = ZHRefreshKeys.headerLastUpdatedTimeKey
        }
    }
}
