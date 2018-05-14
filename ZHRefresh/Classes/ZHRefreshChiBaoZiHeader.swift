//
//  ZHRefreshChiBaoZiHeader.swift
//  Refresh
//
//  Created by SummerHF on 02/05/2018.
//  Copyright © 2018 summer. All rights reserved.
//

import UIKit

public class ZHRefreshChiBaoZiHeader: ZHRefreshGifHeader {

    override public func prepare() {
        super.prepare()
        /// 设置普通状态的动画图片
        var idleImages = [UIImage]()
        for i in 1...60 {
            let string = String(format: "dropdown_anim__000%zd", i)
            let image = UIImage(named: string)!
            idleImages.append(image)
        }
        set(images: idleImages, state: .idle)
        /// 设置即将刷新状态的动画图片
        var refreshingImages = [UIImage]()
        for i in 1...3 {
            let string = String(format: "dropdown_anim__000%zd", i)
            let image = UIImage(named: string)!
            refreshingImages.append(image)
        }
        set(images: refreshingImages, state: .pulling)
        /// 设置正在刷新状态的动画图片
        set(images: refreshingImages, state: .refreshing)
    }
}
