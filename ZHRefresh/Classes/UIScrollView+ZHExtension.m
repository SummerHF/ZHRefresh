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
#import "ZHRefreshRunTime.h"
#import <objc/runtime.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunguarded-availability-new"

static BOOL gt_ios_11_;
static NSString  *const ZHRefreshReloadDataKey = @"ZHRefreshReloadDataKey";
#pragma mark - UIScrollView + ZHExtension

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

#pragma mark - other

/** 计算tableView或者collectionView的cell总个数*/

- (NSInteger)zh_totalCount {
    NSInteger totalCount = 0;
    if ([self isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self;
        for (NSInteger section = 0; section < tableView.numberOfSections; section++) {
            totalCount += [tableView numberOfRowsInSection:section];
        }
    } else if ([self isKindOfClass:[UICollectionView class]]) {
        UICollectionView * collectionView = (UICollectionView *)self;
        for (NSInteger section = 0; section < collectionView.numberOfSections; section++) {
            totalCount += [collectionView numberOfItemsInSection:section];
        }
    }
    return totalCount;
}

- (void)setZh_reloadDataBlock:(void (^)(NSInteger))zh_reloadDataBlock {
    /// KVO zh_reloadDataBlock属性发生了改变
    [self willChangeValueForKey:@"zh_reloadDataBlock"];
    objc_setAssociatedObject(self, &ZHRefreshReloadDataKey, zh_reloadDataBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"zh_reloadDataBlock"];
}

-(void (^)(NSInteger))zh_reloadDataBlock {
    return objc_getAssociatedObject(self, &ZHRefreshReloadDataKey);
}

- (void)executeReloadDataBlock {
    /// 如果zh_reloadDataBlock属性不为空, 那么调用block并且回调cell总个数
    !self.zh_reloadDataBlock ? : self.zh_reloadDataBlock(self.zh_totalCount);
}

@end

#pragma mark - NSObject (ZHExtension) 

@implementation NSObject (ZHExtension)

/**hook实例方法*/
+ (void)exchangeInstanceMethod:(SEL)methond1 method2:(SEL)method2 {
    method_exchangeImplementations(class_getInstanceMethod(self, methond1), class_getInstanceMethod(self, method2));
}

/**hook类方法*/
+ (void)exchangeClassMethod:(SEL)methond1 method2:(SEL)method2 {
    method_exchangeImplementations(class_getClassMethod(self, methond1), class_getClassMethod(self, method2));
}

@end

#pragma mark - UITableView (ZHExtension)

@implementation UITableView (ZHExtension)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self exchangeInstanceMethod:@selector(reloadData) method2:@selector(zh_reloadData)];
    });
}

- (void)zh_reloadData {
    [self zh_reloadData];
    [self executeReloadDataBlock];
}

@end


@implementation UICollectionView (ZHExtension)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self exchangeInstanceMethod:@selector(reloadData) method2:@selector(zh_reloadData)];
    });
}

- (void)zh_reloadData {
    [self zh_reloadData];
    [self executeReloadDataBlock];
}

@end

#pragma mark - NSBundle + ZHExtension

@implementation NSBundle (ZHExtension)

+ (instancetype)zh_refreshBundle {
    static NSBundle *refreshBundle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        /** if nil may cause crash
         /Users/hero/Library/Developer/CoreSimulator/Devices/00A855F7-03DA-4FB9-9A65-8843230FDE84/data/Containers/Bundle/Application/69C5C096-2B3A-4A43-94E6-8203EEEB55EC/ZHRefresh_Example.app/Frameworks/ZHRefresh.framework/ZHRefresh.bundle
         */
        NSString * bundlePath = [[NSBundle bundleForClass:[ZHRefreshRuntime class]] pathForResource:@"ZHRefresh" ofType:@"bundle"];
        refreshBundle = [NSBundle bundleWithPath:bundlePath];
    });
    return refreshBundle;
}

+ (NSString *)zh_localizedStringForKey:(NSString *)key {
    return [self zh_localizedStringForKey:key value:nil];
}

+ (NSString *)zh_localizedStringForKey:(NSString *)key value:(NSString *)value {
    static NSBundle * bundle = nil;
    if (bundle == nil) {
        /// （iOS获取的语言字符串比较不稳定）目前框架只处理en、zh-Hans、zh-Hant三种情况，其他按照系统默认处理
        NSString *language = [NSLocale preferredLanguages].firstObject;
        if ([language hasPrefix:@"en"]) {
            language = @"en";
        } else if ([language hasPrefix:@"zh"]) {
            if ([language rangeOfString:@"Hans"].location != NSNotFound) {
                /// 简体中文
                language = @"zh-Hans";
            } else {
                /// zh-Hant\zh-HK\zh-TW, 繁体中文
                language = @"zh-Hant";
            }
        } else {
            language = @"en";
        }
        NSString * resourcePath = [[NSBundle zh_refreshBundle] pathForResource:language ofType:@"lproj"];
        bundle = [NSBundle bundleWithPath:resourcePath];
    }
    value = [bundle localizedStringForKey:key value:value table:nil];
    return [[NSBundle mainBundle] localizedStringForKey:key value:value table:nil];
}

@end

@implementation UILabel (ZHExtension)

- (CGFloat)zh_textWidth {
    CGFloat stringWidth = 0;
    CGSize size = CGSizeMake(MAXFLOAT, MAXFLOAT);
    if (self.text.length > 0) {
        stringWidth = [self.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.font} context:nil].size.width;
    }
    return  stringWidth;
}

@end
#pragma clang diagnostic pop
