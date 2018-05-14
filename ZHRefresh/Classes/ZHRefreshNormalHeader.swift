//  ZHRefreshNormalHeader.swift
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

/// 默认的下拉刷新控件
public class ZHRefreshNormalHeader: ZHRefreshStateHeader {
    private var _arrowView: UIImageView?
    private var _loadingView: UIActivityIndicatorView?
    /// 默认`.gray`
    public var activityStyle: UIActivityIndicatorViewStyle = .gray {
        didSet {
            self._loadingView = nil
            self.setNeedsLayout()
        }
    }
    /// 箭头
    public var arrowView: UIImageView! {
        if _arrowView == nil {
           let image = UIImage.bundleImage(name: "arrow@2x")
           _arrowView = UIImageView(image: image)
           self.addSubview(_arrowView!)
        }
        return _arrowView
    }
    /// 菊花
    public var loadingView: UIActivityIndicatorView! {
        if _loadingView == nil {
            _loadingView = UIActivityIndicatorView(activityIndicatorStyle: activityStyle)
            self.addSubview(_loadingView!)
        }
        return _loadingView
    }

    // MARK: - 重写父类的方法
    override public func prepare() {
        super.prepare()
        self.activityStyle = .gray
    }

    override public func placeSubViews() {
        super.placeSubViews()
        var arrowCenterX = self.zh_w * 0.5
        if !self.stateLable.isHidden {
            let stateWidth = self.stateLable.zh_textWidth()
            var timeWidth: CGFloat = 0.0
            if !self.lastUpdatedTimeLable.isHidden {
                timeWidth = self.lastUpdatedTimeLable.zh_textWidth()
            }
            let textWidth = max(stateWidth, timeWidth)
            arrowCenterX -= textWidth / 2.0 + self.lableLeftInset
        }
        let arrowCenterY = self.zh_h * 0.5
        let center = CGPoint(x: arrowCenterX, y: arrowCenterY)
        if arrowView.constraints.count == 0 , let image = self.arrowView.image {
            self.arrowView.zh_size = image.size
            self.arrowView.center = center
        }
        if self.loadingView.constraints.count == 0 {
            self.loadingView.center = center
        }
        self.arrowView.tintColor = self.stateLable.tintColor
    }

    override public var state: ZHRefreshState {
        /// check date
        get {
           return super.state
        }
        /// 更具状态做事情
        set {
            guard let oldState = check(newState: newValue, oldState: state) else { return }
            super.state = newValue
            if newValue == .idle {
                if oldState == .refreshing {
                    self.arrowView.transform = CGAffineTransform.identity
                    UIView.animate(withDuration: ZHRefreshKeys.slowAnimateDuration, animations: {
                        self.loadingView.alpha = 0.0
                    }) { (finished) in
                        /// 如果执行完动画发现不是`idle`状态, 就直接返回, 进入其他状态
                        if self.state != .idle { return }
                        self.loadingView.alpha = 1.0
                        self.loadingView.stopAnimating()
                        self.arrowView.isHidden = false
                    }
                } else {
                    self.loadingView.stopAnimating()
                    self.arrowView.isHidden = false
                    UIView.animate(withDuration: ZHRefreshKeys.fastAnimateDuration, animations: {
                        self.arrowView.transform = CGAffineTransform.identity
                    })
                }
            } else if newValue == .pulling {
                self.loadingView.stopAnimating()
                self.arrowView.isHidden = false
                UIView.animate(withDuration: ZHRefreshKeys.fastAnimateDuration, animations: {
                    self.arrowView.transform = CGAffineTransform(rotationAngle: 0.000001 - .pi)
                })
            } else if newValue == .refreshing {
                self.loadingView.alpha = 1.0
                self.loadingView.startAnimating()
                self.arrowView.isHidden = true
            }
        }
    }
}
