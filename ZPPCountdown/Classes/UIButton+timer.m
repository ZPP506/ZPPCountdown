//
//  UIButton+timer.m
//  LoginDemo
//
//  Created by admin on 2020/5/7.
//  Copyright © 2020 yk-mengqingling. All rights reserved.
//

#import "UIButton+timer.h"
#import <objc/runtime.h>

#define KEnterBackgroundTimeKey @"Time_ApplicationDidEnterBackgroundForTime"

@interface UIButton()

@property (nonatomic, assign) __block NSInteger timeAll;

@end

@implementation UIButton (timer)
- (void)setTimeAll:(NSInteger)timeAll{
    objc_setAssociatedObject(self, @selector(timeAll), @(timeAll), OBJC_ASSOCIATION_ASSIGN);
}
- (NSInteger)timeAll{
   NSNumber * number = objc_getAssociatedObject(self, @selector(timeAll));
    return number.integerValue;
}
- (void)startTimer:(NSInteger)during
{
    [self startTimerForeground:@"s" end:@"重新获取验证码" During:during userInteractionEnabled:NO EndComplete:nil];
    
   
}
- (void)startTimer:(NSInteger)during
       endComplete:(void (^)(void))completeBlock
{
    [self startTimerForeground:@"s" end:@"重新获取验证码" During:during userInteractionEnabled:NO EndComplete:completeBlock];
}
/// 倒计时
/// @param foreground title
/// @param end 结束title
/// @param during 倒计时开始时间
/// @param userInteractionEnabled 倒计时中是否允许用户交互
/// @param completeBlock 倒计时完成回调
- (void)startTimerForeground:(NSString *)foreground
                         end:(NSString *)end
                      During:(NSInteger)during
      userInteractionEnabled:(BOOL)userInteractionEnabled
                 EndComplete:(void(^)(void))completeBlock
{
    // 开始监听进入后台 ios 9之后不必移除观察者
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name: UIApplicationDidEnterBackgroundNotification object:nil];
    
    self.timeAll = during;
    [self cancelTime];
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    objc_setAssociatedObject(self, @"zpp_time", timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    dispatch_source_set_event_handler(timer, ^{
        self.timeAll --;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.timeAll <= 0) {
                [self setTitle:[NSString stringWithFormat:@"%@",end] forState:UIControlStateNormal];
                [self.titleLabel sizeToFit];
                dispatch_cancel(timer);
                self.userInteractionEnabled = YES;
                if (completeBlock != nil) {
                    completeBlock();
                }
                return ;
            }
            [self setTitle:[NSString stringWithFormat:@"%zd%@",self.timeAll,foreground] forState:UIControlStateNormal];
            
            [self.titleLabel sizeToFit];
            self.userInteractionEnabled = userInteractionEnabled;
        });
    });
    dispatch_resume(timer);
    
}
#pragma mark -

- (void)applicationWillEnterForeground{
   NSDate * date = [[NSUserDefaults standardUserDefaults] objectForKey:KEnterBackgroundTimeKey];
   NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:date];
    NSInteger time = self.timeAll - ceil(timeInterval);
   [self startTimer:time];
}
- (void)applicationEnterBackground{
    [self cancelTime];
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:KEnterBackgroundTimeKey];
}

#pragma mark -
- (void)cancelTime
{
    dispatch_source_t time =(dispatch_source_t) objc_getAssociatedObject(self, @"zpp_time");
    if (time) {
        dispatch_cancel(time);
    }
}

@end
