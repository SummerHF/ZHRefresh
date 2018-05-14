//  ZHRefreshKeys.swift
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

/// 输出调试信息
public func printf<T>(_ message: T, fileName: String = #file, methodName: String = #function, lineNumber: Int = #line) {
    #if DEBUG
    print("[函数名 : \((fileName as NSString).lastPathComponent) \(methodName)]-->[行号 : \(lineNumber)]\n--->> \(message)")
    #endif
}

/// Key - Value
public struct ZHRefreshKeys {

    public static let bundleName = "ZHRefresh.bundle"
    /// key path 
    public static var header = "header"
    public static var footer = "header"
    /// 最后一次下拉刷新存储时间对应的key
    public static let headerLastUpdatedTimeKey = "headerLastUpdatedTimeKey"
    public static let contentOffset = "contentOffset"
    public static let contentInSet = "contentInset"
    public static let contentSize = "contentSize"
    public static let panState = "state"

    /// animate duration
    public static let fastAnimateDuration: TimeInterval = 0.25
    public static let slowAnimateDuration: TimeInterval = 0.4
    /// height and width
    /// 刷新控件的高度
    public static let headerHeight: CGFloat = 54.0
    public static let footerHeight: CGFloat = 44.0
    public static let lableLeftInset: CGFloat = 25.0
    /// 本地化
    public static let headerIdleText = "ZHRefreshHeaderIdleText"
    public static let headerPullingText = "ZHRefreshHeaderPullingText"
    public static let headerRefreshingText = "ZHRefreshHeaderRefreshingText"

    public static let autoFooterIdleText = "ZHRefreshAutoFooterIdleText"
    public static let autoFooterRefreshingText = "ZHRefreshAutoFooterRefreshingText"
    public static let autoFooterNoMoreDataText = "ZHRefreshAutoFooterNoMoreDataText"

    public static let backFooterIdleText = "ZHRefreshBackFooterIdleText"
    public static let backFooterPullingText = "ZHRefreshBackFooterPullingText"
    public static let backFooterRefreshingText = "ZHRefreshBackFooterRefreshingText"
    public static let backFooterNoMoreDataText = "ZHRefreshBackFooterNoMoreDataText"

    public static let headerLastTimeText = "ZHRefreshHeaderLastTimeText"
    public static let headerDateTodayText = "ZHRefreshHeaderDateTodayText"
    public static let headerNoneLastDateText = "ZHRefreshHeaderNoneLastDateText"
}
