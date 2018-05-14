//  UIScrollView+ZHExtension.h
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

#import <UIKit/UIKit.h>

@interface UIScrollView (ZHExtension)

@property(nonatomic, readonly) UIEdgeInsets zh_inset;

@property(nonatomic, assign) CGFloat zh_insertT;
@property(nonatomic, assign) CGFloat zh_insertB;
@property(nonatomic, assign) CGFloat zh_insertL;
@property(nonatomic, assign) CGFloat zh_insertR;

@property(nonatomic, assign) CGFloat zh_offsetX;
@property(nonatomic, assign) CGFloat zh_offsetY;

@property(nonatomic, assign) CGFloat zh_contentW;
@property(nonatomic, assign) CGFloat zh_contentH;

#pragma mark - other

@property(nonatomic, copy)void (^zh_reloadDataBlock)(NSInteger totalCount);

- (NSInteger)zh_totalCount;

@end

@interface NSBundle (ZHExtension)

+ (instancetype)zh_refreshBundle;
+ (NSString *)zh_localizedStringForKey:(NSString *)key;
+ (NSString *)zh_localizedStringForKey:(NSString *)key value:(NSString *)value;

@end

@interface UILabel (ZHExtension)

- (CGFloat)zh_textWidth;

@end
