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

typealias lastUpdatedTimeTextBlock = (Date) -> String

/// 带有状态文字的下拉刷新控件
class ZHRefreshStateHeader: ZHRefreshHeader {

    // MARK: - 刷新时间相关

    var lastUpdatedTimeTextBlcok: lastUpdatedTimeTextBlock?

    private weak var _lastUpdatedTimeLable: UILabel?
    /// 显示上一次刷新时间的lable
    var lastUpdatedTimeLable: UILabel! {
        if _lastUpdatedTimeLable == nil {
           _lastUpdatedTimeLable = UILabel.zh_lable()
           self.addSubview(_lastUpdatedTimeLable!)
        }
        return _lastUpdatedTimeLable
    }

    /// 显示刷新状态的lable
    private weak var _stateLable: UILabel?
    var stateLable: UILabel! {
        if _stateLable == nil {
           _stateLable = UILabel.zh_lable()
           self.addSubview(_stateLable!)
        }
        return _stateLable
    }

    // MARK: - 状态相关

    var lableLeftInset: CGFloat = 0.0
    /// 所有状态对应的文字
    private var stateTitles: [ZHRefreshState: String] = [ZHRefreshState: String]()

    /// 设置state状态下的文字
    func set(title: String?, for state: ZHRefreshState) {
         if title == nil { return }
         self.stateTitles[state] = title
         self.stateLable.text = self.stateTitles[state]
    }

    // MARK: - Key的处理

    override var lastUpdatedTimeKey: String {
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
                printf(timeStr)
                printf(isToday)
                self.lastUpdatedTimeLable.text = "你好啊"
            } else {
                self.lastUpdatedTimeLable.text = "朱海飞"
            }
        }
    }

    // MARK: - 日历获取方法

    func currentCalendar() -> Calendar {
        return Calendar.current
    }

    // MARK: - 重写父类的方法

    override func prepare() {
        super.prepare()
        self.lableLeftInset = ZHRefreshKeys.lableLeftInset
        
    }
}
