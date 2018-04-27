//
//  ZHRefreshRunTime.h
//  Refresh
//
//  Created by SummerHF on 27/04/2018.
//  Copyright © 2018 summer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHRefreshRuntime : NSObject

/** objc_msgSend不能使用纯OC实现 这里借助OC来完成 */
+(BOOL)target:(id)target canPerformSelector:(SEL)selctor;
/** 发送消息 */
+(void)target:(id)target performSelector:(SEL)selctor view:(UIView *)view;

@end
