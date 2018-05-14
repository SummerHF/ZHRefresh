//  ZHRefreshAutoGifFooter.swift
//  Refresh
//
//  Created by SummerHF on 10/05/2018.
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

/// 带动图的上拉刷新控件
public class ZHRefreshAutoGifFooter: ZHRefreshAutoStateFooter {
    private var _gifImageView: UIImageView?
    /// 只读属性
    public var gifImageView: UIImageView! {
        if _gifImageView == nil {
            _gifImageView = UIImageView()
            self.addSubview(_gifImageView!)
        }
        return _gifImageView
    }
    
    private lazy var stateImages: [ZHRefreshState: [UIImage]] = {
        let array = [ZHRefreshState: [UIImage]]()
        return array
    }()
    
    private lazy var stateDurations: [ZHRefreshState: TimeInterval] = {
        let array = [ZHRefreshState: TimeInterval]()
        return array
    }()
    
    // MARK: - Public method
    
    /// 设置对应状态下的图片 以及动画时间
    public func set(images: [UIImage], duration: TimeInterval, state: ZHRefreshState) {
        self.stateImages[state] = images
        self.stateDurations[state] = duration
        if let image = images.first {
            /// 根据图片设置控件的高度
            if image.size.height > self.zh_h {
                self.zh_h = image.size.height
            }
        }
    }
    
    public func set(images: [UIImage], state: ZHRefreshState) {
        set(images: images, duration: TimeInterval(CGFloat(images.count) * 0.1), state: state)
    }
    
    // MARK: - override method
    
    override public func prepare() {
        super.prepare()
        /// 初始化间距
        self.lableLeftInset = 20
    }
    
    override public func placeSubViews() {
        super.placeSubViews()
        if gifImageView.constraints.count == 0 {
            self.gifImageView.frame = self.bounds
            if self.refreshingTitleHidden {
                self.gifImageView.contentMode = .center
            } else {
                self.gifImageView.contentMode = .right
                self.gifImageView.zh_w = self.zh_w * 0.5 - self.lableLeftInset - self.stateLable.zh_textWidth() * 0.5
            }
        }
    }
    
    override public var state: ZHRefreshState {
        get {
            return super.state
        }
        set {
            guard check(newState: newValue, oldState: state) != nil else { return }
            super.state = newValue
            if newValue == .refreshing {
                if let images = self.stateImages[newValue], let duration = self.stateDurations[newValue], images.count > 0 {
                    self.gifImageView.isHidden = false
                    self.gifImageView.stopAnimating()
                    if images.count == 1 {
                        self.gifImageView.image = images.first!
                    } else {
                        /// 多张图片
                        self.gifImageView.animationImages = images
                        self.gifImageView.animationDuration = duration
                        self.gifImageView.startAnimating()
                    }
                }
            } else if state == .idle || state == .nomoreData {
                self.gifImageView.stopAnimating()
                self.gifImageView.isHidden = true
            }
        }
    }
}
