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

extension UIScrollView {

    var header: ZHRefreshHeader {
        get {
            return objc_getAssociatedObject(self, &ZHRefreshKeys.header) as! ZHRefreshHeader
        }
        set {
            if self.header != newValue {
                /// 移除旧值
                self.header.removeFromSuperview()
                self.addSubview(header)
                /// 存储新的
                /// KVO
                self.willChangeValue(forKey: ZHRefreshKeys.header)
                objc_setAssociatedObject(self, &ZHRefreshKeys.header, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
                self.didChangeValue(forKey: ZHRefreshKeys.header)
            }
        }
    }
}
