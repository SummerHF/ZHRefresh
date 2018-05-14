//  ZHRefreshChiBaoZiFooter.swift
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

public class ZHRefreshChiBaoZiFooter: ZHRefreshBackGifFooter {

    override public func prepare() {
        super.prepare()
        /// 设置普通状态的动画图片
        var idleImages = [UIImage]()
        for i in 1...60 {
            let string = String(format: "dropdown_anim__000%zd@2x", i)
            let image = UIImage.bundleImage(name: string)!
            idleImages.append(image)
        }
        set(images: idleImages, state: .idle)
        /// 设置即将刷新状态的动画图片
        var refreshingImages = [UIImage]()
        for i in 1...3 {
            let string = String(format: "dropdown_anim__000%zd@2x", i)
            let image = UIImage.bundleImage(name: string)!
            refreshingImages.append(image)
        }
        set(images: refreshingImages, state: .pulling)
        /// 设置正在刷新状态的动画图片
        set(images: refreshingImages, state: .refreshing)
    }
}
