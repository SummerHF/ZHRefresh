//  ZHDIYHeader.swift
//  ZHRefresh
//
//  Created by SummerHF on 14/05/2018.
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

import ZHRefresh

/// 如果使用DIY header, 必须继承该基类(使用open修饰), 无法继承其他(header类, ZHRefreshComponent除外)
class ZHDIYHeader: ZHRefreshHeader {

    var lable: UILabel!
    var switchBtn: UISwitch!
    var loadingView: UIActivityIndicatorView!
    
    // MARK: - 初始化设置, 比如添加子控件
    override open func prepare() {
        super.prepare()
        self.zh_h = 50
        /// 添加lable
        self.lable = UILabel.zh_lable()
        self.addSubview(self.lable)
        /// 开关
        self.switchBtn = UISwitch()
        self.addSubview(self.switchBtn)
        /// 菊花
        self.loadingView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        self.addSubview(self.loadingView)
    }

    // MARK: - 设置子控件的大小

    override open func placeSubViews() {
        super.placeSubViews()
        self.lable.frame = self.bounds
        self.switchBtn.bounds = CGRect(x: 20, y: 0, width: self.zh_w * 0.2, height: self.zh_h * 0.5)
        self.loadingView.center = CGPoint(x: self.zh_w - 30 , y: self.zh_h * 0.5)
    }

    // MARK: - 监听偏移量

    override open func scrollViewContentOffsetDid(change: [NSKeyValueChangeKey: Any]) {
        super.scrollViewContentOffsetDid(change: change)
    }

    // MARK: - 监听contentSize 

    override open func scrollViewContentSizeDid(change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewContentSizeDid(change: change)
    }

    // MARK: - 监听控件的刷新状态

    override open var state: ZHRefreshState {
        get {
            return super.state
        }
        set {
            guard check(newState: newValue, oldState: state) != nil else { return }
            super.state  = newValue
            switch newValue {
            case .idle:
                self.loadingView.stopAnimating()
                self.lable.text = "赶紧下拉吖(开关是打酱油滴)"
                self.switchBtn.isOn = false
            case .pulling:
                self.loadingView.stopAnimating()
                self.lable.text = "赶紧放开我吧(开关是打酱油滴)"
                self.switchBtn.isOn = false
            case .refreshing:
                self.loadingView.stopAnimating()
                self.lable.text = "加载数据中(开关是打酱油滴)"
                self.switchBtn.isOn = true
            default:
                break
            }
        }
    }

    // MARK: - 监听拖拽比例 

    override open var pullingPercent: CGFloat {
        didSet {
            let red = 1.0 - pullingPercent * 0.5
            let green = 0.5 - 0.5 * pullingPercent
            let blue = 0.5 * pullingPercent
            self.lable.textColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
}
