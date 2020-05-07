//
//  ZPPViewController.m
//  ZPPCountdown
//
//  Created by 张朋朋 on 05/07/2020.
//  Copyright (c) 2020 张朋朋. All rights reserved.
//

#import "ZPPViewController.h"
#import "UIButton+timer.h"

@interface ZPPViewController ()

@end

@implementation ZPPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)touchBeginButton:(UIButton *)sender {
    
    [sender startTimer:60];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
