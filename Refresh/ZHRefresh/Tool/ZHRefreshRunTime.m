//
//  ZHRefreshRunTime.m
//  Refresh
//
//  Created by SummerHF on 27/04/2018.
//  Copyright © 2018 summer. All rights reserved.
//

#import "ZHRefreshRuntime.h"
#import <objc/message.h>

// 运行时objc_msgSend
#define ZHRefreshMsgSend(...) ((void (*)(void *, SEL, UIView *))objc_msgSend)(__VA_ARGS__)
#define ZHRefreshMsgTarget(target) (__bridge void *)(target)

@implementation ZHRefreshRuntime

+(BOOL)target:(id)target canPerformSelector:(SEL)selctor {
    return [target respondsToSelector:selctor];
}

+(void)target:(id)target performSelector:(SEL)selctor view:(UIView *)view {
    ZHRefreshMsgSend(ZHRefreshMsgTarget(target), selctor, view);
}

@end
