//  UIScrollView+ZHExtension.m
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

#import "UIScrollView+ZHExtension.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunguarded-availability-new"

static BOOL gt_ios_11_;

@implementation UIScrollView (ZHExtension)

+ (void)load {
    /// 缓存判断值
    /// 当前系统版本小于11, 趋势递增
    /// 当前系统版本大于11或者等于11, 趋势递减
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gt_ios_11_ = ([[[UIDevice currentDevice] systemVersion] compare:@"11" options:NSNumericSearch] != NSOrderedAscending);
    });
}

- (UIEdgeInsets)zh_inset {
#ifdef __IPHONE_11_0
    if (gt_ios_11_) {
        return self.adjustedContentInset;
    }
#endif
    return self.contentInset;
}

- (CGFloat)zh_insertT {
    return self.zh_inset.top;
}

- (void)setZh_insertT:(CGFloat)zh_insertT {
    UIEdgeInsets inset = self.contentInset;
    inset.top = zh_insertT;
#ifdef __IPHONE_11_0
    if (gt_ios_11_) {
        inset.top -= (self.adjustedContentInset.top - self.contentInset.top);
    }
#endif
    self.contentInset = inset;
}

- (CGFloat)zh_insertB {
    return self.zh_inset.bottom;
}

- (void)setZh_insertB:(CGFloat)zh_insertB {
    UIEdgeInsets inset = self.contentInset;
    inset.bottom = zh_insertB;
#ifdef __IPHONE_11_0
    if (gt_ios_11_) {
        inset.bottom -= (self.adjustedContentInset.bottom - self.contentInset.bottom);
    }
#endif
    self.contentInset = inset;
}

- (CGFloat)zh_insertL {
    return self.zh_inset.left;
}

- (void)setZh_insertL:(CGFloat)zh_insertL {
    UIEdgeInsets inset = self.contentInset;
    inset.left = zh_insertL;
#ifdef __IPHONE_11_0
    if (gt_ios_11_) {
        inset.left -= (self.adjustedContentInset.left - self.contentInset.left);
    }
#endif
    self.contentInset = inset;
}

- (CGFloat)zh_insertR {
    return self.zh_inset.right;
}

- (void)setZh_insertR:(CGFloat)zh_insertR {
    UIEdgeInsets inset = self.contentInset;
    inset.right = zh_insertR;
#ifdef __IPHONE_11_0
    if (gt_ios_11_) {
        inset.right -= (self.adjustedContentInset.right - self.contentInset.right);
    }
#endif
    self.contentInset = inset;
}

- (CGFloat)zh_offsetX {
    return  self.contentOffset.x;
}

- (void)setZh_offsetX:(CGFloat)zh_offsetX {
    CGPoint offset = self.contentOffset;
    offset.x = zh_offsetX;
    self.contentOffset = offset;
}

- (CGFloat)zh_offsetY {
    return self.contentOffset.y;
}

- (void)setZh_offsetY:(CGFloat)zh_offsetY {
    CGPoint offset = self.contentOffset;
    offset.y = zh_offsetY;
    self.contentOffset = offset;
}

- (CGFloat)zh_contentW {
    return self.contentSize.width;
}

- (void)setZh_contentW:(CGFloat)zh_contentW {
    CGSize size = self.contentSize;
    size.width = zh_contentW;
    self.contentSize = size;
}

- (CGFloat)zh_contentH {
    return self.contentSize.height;
}

- (void)setZh_contentH:(CGFloat)zh_contentH {
    CGSize size = self.contentSize;
    size.height = zh_contentH;
    self.contentSize = size;
}

@end
#pragma clang diagnostic pop
