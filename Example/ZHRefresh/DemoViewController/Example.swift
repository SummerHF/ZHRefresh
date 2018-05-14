//  Example.swift
//  Refresh
//
//  Created by macbookair on 2018/5/10.
//
//
//  Copyright (c) 2018 macbookair(https://github.com/summerhf)
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

let Example00 = "UITableView + 下拉刷新";
let Example10 = "UITableView + 上拉加载";
let Example20 = "UICollectionView";
let Example30 = "UIWebView";

/// 模型数据
class Example: NSObject {
    /// 复用标示
    static let reuseIdentifier: String = "Example"
    static let headerHeight: CGFloat = 36
    static let footerHeight: CGFloat = 0.0001
    static let method: String = "method"
    var header: String
    var titles: [String]
    var methods: [String]
    var vcType: AnyClass

    init(header: String, titles: [String], methods: [String], classType: AnyClass) {
        self.header = header
        self.titles = titles
        self.methods = methods
        self.vcType = classType
        super.init()
    }

    /// 类方法 快速的创建模型
    static func retriveData() -> [Example] {
        var models = [Example]()
        /// 6
        let example00 = Example(header: Example00, titles: ["默认", "动画图片", "隐藏时间", "隐藏状态和时间", "自定义文字", "自定义刷新控件"], methods: ["action01", "action02", "action03", "action04", "action05", "action06"], classType: TableViewController.classForCoder())
        /// 11
        let example01 = Example(header: Example10, titles: ["默认", "动画图片", "隐藏刷新状态的文字", "全部加载完毕", "禁止自动加载", "自定义文字", "加载后隐藏", "自动回弹的上拉01", "自动回弹的上拉02", "自定义刷新控件(自动刷新)", "自定义刷新控件(自动回弹)"], methods: ["action07", "action08", "action09", "action10", "action11", "action12", "action13", "action14", "action15", "action16","action17"], classType: TableViewController.classForCoder())
        /// 1
        let example02 = Example(header: Example20, titles: ["上下拉刷新"], methods: ["action18"], classType: CollectionViewController.classForCoder())
        /// 1
        let example03 = Example(header: Example30, titles: ["下拉刷新"], methods: ["action19"], classType: WebViewController.classForCoder())
        models.append(example00)
        models.append(example01)
        models.append(example02)
        models.append(example03)
        return models
    }
}
