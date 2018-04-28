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
struct ZHRefreshKeys {

    /// key path 
    static var header = "header"
    /// 最后一次下拉刷新存储时间对应的key
    static let headerLastUpdatedTimeKey = "headerLastUpdatedTimeKey"
    static let contentOffset = "contentOffset"
    static let contentInSet = "contentInset"
    static let contentSize = "contentSize"
    static let panState = "state"

    /// animate duration
    static let fastAnimateDuration: TimeInterval = 0.25
    static let slowAnimateDuration: TimeInterval = 0.4
    /// height and width
    /// 刷新控件的高度
    static let headerHeight: CGFloat = 54.0
}
