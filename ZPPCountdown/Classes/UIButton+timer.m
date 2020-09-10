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
typedef void(^CompleteBlock)(void);

@property (nonatomic, assign) __block NSInteger timeAll;
@property (nonatomic, strong) NSString * timerForeground;
@property (nonatomic, strong) NSString * forwordTime;
@property (nonatomic, strong) NSString * end;
@property (nonatomic, strong) CompleteBlock completeBlock;
@property (nonatomic, assign) BOOL isCanUserInterface;

@end

@implementation UIButton (timer)
- (void)setTimeAll:(NSInteger)timeAll{
    objc_setAssociatedObject(self, @selector(timeAll), @(timeAll), OBJC_ASSOCIATION_ASSIGN);
}
- (NSInteger)timeAll{
   NSNumber * number = objc_getAssociatedObject(self, @selector(timeAll));
    return number.integerValue;
}
- (void)setIsCanUserInterface:(BOOL)isCanUserInterface{
    objc_setAssociatedObject(self, @selector(isCanUserInterface), @(isCanUserInterface), OBJC_ASSOCIATION_ASSIGN);
}
- (BOOL)isCanUserInterface{
   NSNumber * number = objc_getAssociatedObject(self, @selector(isCanUserInterface));
    return number.boolValue;
}
- (void)setTimerForeground:(NSString *)timerForeground{
    objc_setAssociatedObject(self, @selector(timerForeground), timerForeground, OBJC_ASSOCIATION_COPY);
}
- (NSString *)timerForeground{
   NSString * string = objc_getAssociatedObject(self, @selector(timerForeground));
    return string;
}
- (void)setForwordTime:(NSString *)forwordTime{
    objc_setAssociatedObject(self, @selector(forwordTime), forwordTime, OBJC_ASSOCIATION_COPY);
}
- (NSString *)forwordTime{
   NSString * string = objc_getAssociatedObject(self, @selector(forwordTime));
    return string;
}
- (void)setEnd:(NSString *)end{
    objc_setAssociatedObject(self, @selector(end), end, OBJC_ASSOCIATION_COPY);
}
- (NSString *)end{
   NSString * string = objc_getAssociatedObject(self, @selector(end));
    return string;
}
- (void)setCompleteBlock:(CompleteBlock)block{
    objc_setAssociatedObject(self, @selector(completeBlock), block, OBJC_ASSOCIATION_COPY);
}
- (CompleteBlock)completeBlock{
   CompleteBlock block = objc_getAssociatedObject(self, @selector(completeBlock));
    return block;
}
- (void)startCancelTimer:(NSInteger)during
       endComplete:(void (^)(void))completeBlock
{
    [self startTimerForeground:@"s" forwordTime: @"放弃" end:@"放弃" During:during userInteractionEnabled:NO EndComplete:completeBlock];
}
- (void)start30sTimer:(NSInteger)during
       endComplete:(void (^)(void))completeBlock
{
    [self startTimerForeground:@"s" forwordTime: @"" end:@"30s" During:during userInteractionEnabled:NO EndComplete:completeBlock];
}
- (void)startTimer:(NSInteger)during
{
    [self startTimerForeground:@"s" forwordTime: @"" end:@"重新获取验证码" During:during userInteractionEnabled:NO EndComplete:nil];
}
- (void)startTimer:(NSInteger)during
       endComplete:(void (^)(void))completeBlock
{
    [self startTimerForeground:@"s" forwordTime: @"" end:@"重新获取验证码" During:during userInteractionEnabled:NO EndComplete:completeBlock];
}
/// 倒计时
/// @param foreground title
/// @param end 结束title
/// @param during 倒计时开始时间
/// @param userInteractionEnabled 倒计时中是否允许用户交互
/// @param completeBlock 倒计时完成回调
- (void)startTimerForeground:(NSString *)foreground
                 forwordTime:(NSString *)forwordTime
                         end:(NSString *)end
                      During:(NSInteger)during
      userInteractionEnabled:(BOOL)userInteractionEnabled
                 EndComplete:(void(^)(void))completeBlock
{
    // 开始监听进入后台 ios 9之后不必移除观察者
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name: UIApplicationDidEnterBackgroundNotification object:nil];
    
    self.forwordTime = forwordTime;
    self.timerForeground = foreground;
    self.end = end;
    self.isCanUserInterface = self.isUserInteractionEnabled;
    self.completeBlock = completeBlock;
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
                self.userInteractionEnabled = self.isCanUserInterface;
                if (completeBlock != nil) {
                    completeBlock();
                }
                return ;
            }
            [self setTitle:[NSString stringWithFormat:@"%@%zd%@",forwordTime,self.timeAll,foreground] forState:UIControlStateNormal];
            
            [self.titleLabel sizeToFit];
            self.userInteractionEnabled = userInteractionEnabled;
        });
    });
    dispatch_resume(timer);
    
}
#pragma mark -

- (void)applicationWillEnterForeground{
    NSString * keyBt = [NSString stringWithFormat:@"%p", self];
    NSDate * date = [[NSUserDefaults standardUserDefaults] objectForKey:keyBt];
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:date];
    NSInteger time = self.timeAll - ceil(timeInterval);
    [self startTimerForeground:self.timerForeground forwordTime: self.forwordTime end:self.end During:time userInteractionEnabled:NO EndComplete:self.completeBlock];
}
- (void)applicationEnterBackground{
    dispatch_source_t time =(dispatch_source_t) objc_getAssociatedObject(self, @"zpp_time");
    if (time) {
        dispatch_cancel(time);
    }
    NSString * keyBt = [NSString stringWithFormat:@"%p", self];
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:keyBt];
}

#pragma mark -
- (void)cancelTime
{
    [self startTimerForeground:self.timerForeground forwordTime: self.forwordTime end:self.end During:0 userInteractionEnabled:NO EndComplete:self.completeBlock];
    dispatch_source_t time =(dispatch_source_t) objc_getAssociatedObject(self, @"zpp_time");
    if (time) {
        dispatch_cancel(time);
    }
}
@end
