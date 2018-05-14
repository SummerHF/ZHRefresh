//  UIView+Extension.swift
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

/// 拓展的工具类

// MARK: - UIImage

public extension UIImage {

    /// 从bundle中提取照片
    static func bundleImage(name: String) -> UIImage? {
        if let path = Bundle.zh_refresh().path(forResource: name, ofType: "png") {
           return UIImage(contentsOfFile: path)?.withRenderingMode(.alwaysOriginal)
        }
        return nil
    }

    /// 从指定bundle中提取照片
    static func appointBundleImage(bundleName: String = ZHRefreshKeys.bundleName, name: String) -> UIImage? {
        let string = bundleName + "/\(name)"
        return UIImage(named: string)
    }
}

// MARK: - UILabel

public extension UILabel {
    
    /// 快速创建lable
    static func zh_lable() -> UILabel {
        let lable = UILabel()
        lable.font = ZHRefreshLableFont
        lable.textColor = ZHRefreshLableTextColor
        lable.autoresizingMask = [.flexibleWidth]
        lable.textAlignment = .center
        return lable
    }
}

// MARK: - UIView

public extension UIView {

    var zh_x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            self.frame.origin.x = newValue
        }
    }

    var zh_y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            self.frame.origin.y = newValue
        }
    }

    var zh_w: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            self.frame.size.width = newValue
        }
    }

    var zh_h: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            self.frame.size.height = newValue
        }
    }

    var zh_size: CGSize {
        get {
            return self.frame.size
        }
        set {
            self.frame.size = newValue
        }
    }

    var zh_origin: CGPoint {
        get {
            return self.frame.origin
        }
        set {
            self.frame.origin = newValue
        }
    }
}
