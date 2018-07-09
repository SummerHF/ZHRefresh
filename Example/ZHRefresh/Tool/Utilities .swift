//  Extension.swift
//  DouYin
//
//  Created by SummerHF on 04/06/2018.
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

// MARK: - UILable

extension UILabel {
    
    static func lableWith(_ text: String, font: UIFont, color: UIColor, aligment: NSTextAlignment? = .center) -> UILabel {
        let lable = UILabel()
        lable.text = text
        lable.font = font
        lable.textColor = color
        /// must have value
        lable.textAlignment = aligment!
        return lable
    }
    
    static func lable(title: String? = nil, color: UIColor, font: UIFont, aligment: NSTextAlignment = .center) -> UILabel {
        let lable = UILabel()
        lable.text = title
        lable.textColor = color
        lable.font = font
        lable.textAlignment = aligment
        return lable
    }
}

// MARK: - UIImageView

extension UIImageView {
    
    func rotate() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z") // 让其在z轴旋转
        rotationAnimation.toValue = Float.pi * 2
        rotationAnimation.duration = 0.6 // 旋转周期
        rotationAnimation.isCumulative = true // 旋转累加角度
        rotationAnimation.repeatCount = 1000000 // 旋转次数
        layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    
    func stopRotate() {
        layer.removeAllAnimations()
    }
}

// MARK: - UIScreen

extension UIScreen {
    
    static var width: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    static var height: CGFloat {
        return UIScreen.main.bounds.height
    }
}

// MARK: - UIView

extension UIView {
    
    var x: CGFloat {
        set {
            frame.origin.x = newValue
        }
        get {
            return frame.origin.x
        }
    }
    
    var y: CGFloat {
        set {
            frame.origin.y = newValue
        }
        get {
            return frame.origin.y
        }
    }
    
    var top: CGFloat {
        set {
            frame.origin.y = newValue
        }
        get {
            return frame.origin.y
        }
    }
    
    var bottom: CGFloat {
        get {
            return top + height
        }
        set {
            top = newValue - height
        }
    }
    
    var width: CGFloat {
        get {
            return frame.size.width
        }
        set {
            frame.size.width = newValue
        }
    }
    
    var height: CGFloat {
        get {
            return frame.size.height
        }
        set {
            frame.size.height = newValue
        }
    }
}
