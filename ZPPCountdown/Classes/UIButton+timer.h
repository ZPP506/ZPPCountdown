//
//  UIButton+timer.h
//  LoginDemo
//
//  Created by admin on 2020/5/7.
//  Copyright © 2020 yk-mengqingling. All rights reserved.
//  倒计时使用


#import <UIKit/UIKit.h>


@interface UIButton (timer)

/**Button:创建时候的类型不同闪烁效果不一样
 *UIButtonTypeCustom->普通
 *UIButtonTypeSystem ->闪烁
 */

/// 提示语: 1s ~ 重新发送
/// @param during 倒计时时间
- (void)startTimer:(NSInteger)during;


/// 提示语: 1s ~ 重新发送
/// @param during 倒计时时间
/// @param completeBlock 倒计时完成回调
- (void)startTimer:(NSInteger)during
       endComplete:(void(^)(void))completeBlock;

/// 取消倒计时
- (void)cancelTime;



@end
