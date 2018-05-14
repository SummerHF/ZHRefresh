//  ZHRefreshAutoNormalFooter.swift
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

/// 默认的上拉刷新控件
public class ZHRefreshAutoNormalFooter: ZHRefreshAutoStateFooter {
    /// 菊花
    private var _loadingView: UIActivityIndicatorView?
    /// 默认`.gray`
    public var activityStyle: UIActivityIndicatorViewStyle = .gray {
        didSet {
            self._loadingView = nil
            self.setNeedsLayout()
        }
    }
    /// 菊花
    private var loadingView: UIActivityIndicatorView! {
        if _loadingView == nil {
            _loadingView = UIActivityIndicatorView(activityIndicatorStyle: activityStyle)
            self.addSubview(_loadingView!)
        }
        return _loadingView
    }
    
    // MARK: - override
    
    override public func prepare() {
        super.prepare()
        self.activityStyle = .gray
    }
    
    override public func placeSubViews() {
        super.placeSubViews()
        if self.loadingView.constraints.count == 0 {
            var loadingCenterX = self.zh_w * 0.5
            if !self.refreshingTitleHidden {
                loadingCenterX -= self.lableLeftInset + self.stateLable.zh_textWidth()
            }
            let loadingCenterY = self.zh_h * 0.5
            self.loadingView.center = CGPoint(x: loadingCenterX, y: loadingCenterY)
        }
    }
    
    override public var state: ZHRefreshState {
        get {
            return super.state
        }
        set {
            guard check(newState: newValue, oldState: state) != nil else { return }
            super.state = newValue
            if newValue == .nomoreData || newValue == .idle {
                self.loadingView.stopAnimating()
            } else if state == .refreshing {
                self.loadingView.startAnimating()
            }
        }
    }
}
