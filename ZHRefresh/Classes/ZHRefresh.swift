//  UIScrollView+ZHRefresh.swift
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

public extension UIScrollView {
    
    /// header
     @objc dynamic var header: ZHRefreshHeader? {
        get {
            return objc_getAssociatedObject(self, &ZHRefreshKeys.header) as? ZHRefreshHeader
        }
        set {
            if let newHeader = newValue {
                if let oldHeader = header {
                    /// 如果有旧值, 删除它
                    oldHeader.removeFromSuperview()
                }
                /// 添加新的
                self.insertSubview(newHeader, at: 0)
                /// 存储新值
                objc_setAssociatedObject(self, &ZHRefreshKeys.header, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
            }
        }
    }

    /// footer
     @objc dynamic var footer: ZHRefreshFooter? {
        get {
            return objc_getAssociatedObject(self, &ZHRefreshKeys.footer) as? ZHRefreshFooter
        }
        set {
            if let newFooter = newValue {
                if let oldFooter = footer {
                    /// 如果有旧值, 删除它
                    oldFooter.removeFromSuperview()
                }
                /// 添加新值
                self.insertSubview(newFooter, at: 0)
                /// 存储新值
                objc_setAssociatedObject(self, &ZHRefreshKeys.footer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
            }
        }
    }
}
