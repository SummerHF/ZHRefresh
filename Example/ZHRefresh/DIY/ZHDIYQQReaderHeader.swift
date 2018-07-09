//  ZHDIYQQReaderHeader.swift
//  ZHRefresh
//
//  Created by SummerHF on 09/07/2018.
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
import ZHRefresh

func RGBA(_ r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat)->UIColor {
    return UIColor (red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}

private struct Refresh {
    static let height: CGFloat = 96
    static let idle: Int = 1
    static let pulling: Int = 2
    static let refreshing: Int = 3
    static let willRefresh: Int = 4
    static let animateImageSize: CGSize = CGSize(width: 24, height: 24)
    static let progressSize: CGSize = CGSize(width: 16, height: 16)
    static let successTitle = "刷新成功"
    static let errorTitle = "刷新失败"
    static let bottomOffSet: CGFloat = -10.0
}

/// 所有的颜色相关
struct Color {
    static let blackColor = UIColor.black
    static let grayColor = UIColor.gray
    static let whiteColor = UIColor.white
    static let deepGrayColor = UIColor.gray
    static let shallowGray = RGBA(239, g: 241, b: 242, a: 0.8)
    static let littleGray = RGBA(239, g: 241, b: 242, a: 0.4)
    static let littleGreen = RGBA(11.0, g: 78.0, b: 44.0, a: 1)
    static let shallowGreen = RGBA(47, g: 96, b: 68, a: 1.0)
    static let clearColor = UIColor.clear
    static let navBarBottomLineColor = RGBA(235,g: 235,b: 235,a: 1)
}

/// 所有的字体相关
struct Fonts {
    static let largeFont = UIFont.systemFont(ofSize: 14)
}


// MARK: - 刷新进度指示条

class ZHProgressBar: UIView {
    let progressTint: UIColor = RGBA(15, g: 68, b: 35, a: 0.6)
    let trackTint: UIColor = Color.clearColor
    let lineWidth: CGFloat = 1.5
    
    var progressValue: CGFloat = 0.0 {
        willSet(newValue) {
            self.progressLayer.strokeEnd = newValue
        }
    }
    
    lazy var path: UIBezierPath = {
        let radius = self.frame.size.width / 2
        let path = UIBezierPath(arcCenter: self.center, radius: radius, startAngle: -.pi/2, endAngle: .pi * 1.5, clockwise: true)
        return path
    }()
    
    lazy var shapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.lineWidth = lineWidth
        layer.fillColor = nil
        layer.strokeColor = trackTint.cgColor
        return layer
    }()
    
    lazy var progressLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.lineWidth = lineWidth
        layer.fillColor = nil
        layer.strokeColor = progressTint.cgColor
        layer.lineCap = kCALineCapRound
        layer.strokeEnd = 0.0
        return layer
    }()
    
    override init(frame: CGRect) {
        let frame = CGRect(origin: CGPoint.zero, size: Refresh.progressSize)
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func animate(with percent: CGFloat) {
        var progress: CGFloat = 0.0
        if percent <= 0 {
            progress = 0
        } else if percent >= 1 {
            progress = 1
        } else {
            progress = percent
        }
        self.layer.addSublayer(shapeLayer)
        self.layer.addSublayer(progressLayer)
        self.progressValue = progress
    }
}

// MARK: - 刷新头部

class ZHDIYQQReaderHeader: ZHRefreshHeader {
    
    lazy var progressView = ZHProgressBar()
    
    let headerImage: UIImageView = {
        let view = UIImageView(image: UIImage(named: "header_place_holder"))
        return view
    }()
    
    let animateImage: UIImageView = {
        let view = UIImageView(image: UIImage(named: "card_refresh"))
        view.isHidden = true
        return view
    }()
    
    let titleLable: UILabel = {
        let lable = UILabel.lable(color: Color.deepGrayColor, font: Fonts.largeFont)
        lable.isHidden = true
        return lable
    }()
    
    override var state: ZHRefreshState {
        get {
            return super.state
        }
        set {
            /// check state, 相同的state 直接return
            guard check(newState: newValue, oldState: state) != nil else { return }
            super.state = newValue
            /// 将要刷新
            if newValue == .pulling {
                self.animateImageStopAnimate()
                if #available(iOS 10.0, *) {
                    /// 添加震动反馈
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                }
            } else if newValue == .refreshing {
                /// 正在刷新
                self.animateImageAnimate()
            } else if newValue == .idle {
                self.animateImageStopAnimate()
            } else if newValue == .willRefresh {
                self.animateImageStopAnimate()
            }
        }
    }
    
    override var pullingPercent: CGFloat {
        didSet {
            printf(pullingPercent)
            progressView.animate(with: pullingPercent)
        }
    }
    
    override func prepare() {
        super.prepare()
        self.zh_h = Refresh.height
        self.addSubview(headerImage)
        self.addSubview(progressView)
        self.addSubview(titleLable)
        self.addSubview(animateImage)
        
        headerImage.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(3)
        }
        progressView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(Refresh.bottomOffSet)
            make.size.equalTo(Refresh.progressSize)
        }
        animateImage.snp.makeConstraints { (make) in
            make.center.equalTo(progressView)
            make.size.equalTo(Refresh.animateImageSize)
        }
        titleLable.snp.makeConstraints { (make) in
            make.center.equalTo(animateImage)
        }
    }
    
    /// 结束刷新
    func endRefreshWith(success: Bool) {
        self.animateImageStopAnimate()
        /// 显示刷新提示
        showTitle(success: success)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            /// 隐藏刷新提示
            self.titleLable.isHidden = true
            super.endRefreshingWithCompletionBlock { [weak self] in
                guard let `self` = self else { return }
                self.progressView.isHidden = false
            }
        }
    }
    
    override func placeSubViews() {
        super.placeSubViews()
    }
    
    private func animateImageAnimate() {
        self.progressView.isHidden = true
        self.animateImage.rotate()
        self.animateImage.isHidden = false
    }
    
    private func animateImageStopAnimate() {
        self.animateImage.stopRotate()
        self.animateImage.isHidden = true
    }
    
    private func showTitle(success: Bool) {
        titleLable.isHidden = false
        if success {
            titleLable.text = Refresh.successTitle
        } else {
            titleLable.text = Refresh.errorTitle
        }
    }
}
