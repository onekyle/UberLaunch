//
//  ViewController.m
//  Uber_Lacunch_OC
//
//  Created by Durand on 22/8/16.
//  Copyright © 2016年 com.Durand. All rights reserved.
//

#import "ViewController.h"
#import "AnimatedULogoView.h"

@interface ViewController ()
@property (nonatomic,strong) AnimatedULogoView *animatedView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _animatedView = [[AnimatedULogoView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:_animatedView];
    self.view.backgroundColor = [UIColor blackColor];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_animatedView startAniamting];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
