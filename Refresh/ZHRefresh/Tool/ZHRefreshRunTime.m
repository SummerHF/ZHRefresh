//
//  ZHRefreshRunTime.m
//  Refresh
//
//  Created by SummerHF on 27/04/2018.
//  Copyright © 2018 summer. All rights reserved.
//

#import "ZHRefreshRunTime.h"
#import <objc/message.h>

@implementation ZHRefreshRunTime

+(BOOL)target:(id)target canPerformSelector:(SEL)selctor {
    return [target respondsToSelector:selctor];
}

+(void)target:(id)target performSelector:(SEL)selctor {
    [target performSelector:selctor];
}

@end
