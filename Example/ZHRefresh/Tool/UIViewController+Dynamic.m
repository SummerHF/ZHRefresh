//
//  UIViewController+Dynamic.m
//  ZHRefresh_Example
//
//  Created by SummerHF on 11/05/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

#import "UIViewController+Dynamic.h"
#import <objc/runtime.h>

@implementation UIViewController (Dynamic)

/** 检测是否有内存泄漏 */

+ (void)load {
    Method mehtod1 = class_getInstanceMethod([self class], NSSelectorFromString(@"dealloc"));
    Method method2 = class_getInstanceMethod([self class], @selector(swizzleDealloc));
    method_exchangeImplementations(mehtod1, method2);
}

- (void)swizzleDealloc {
    NSLog(@"%@ ---> 已被释放", self);
    [self swizzleDealloc];
}

static const char key = '\0';

- (void)setMethod:(NSString *)method {
    objc_setAssociatedObject(self, &key, method, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)method {
    return  objc_getAssociatedObject(self, &key);
}

@end
