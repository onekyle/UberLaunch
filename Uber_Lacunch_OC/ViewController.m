//
//  ViewController.m
//  Uber_Lacunch_OC
//
//  Created by Durand on 22/8/16.
//  Copyright © 2016年 com.Durand. All rights reserved.
//

#import "ViewController.h"
#import "AnimatedULogoView.h"
#import "Contans.h"
#import "TileGridView.h"
#import "TileView.h"

@interface ViewController ()
@property (nonatomic,strong) AnimatedULogoView *animatedView;
@property (nonatomic,strong) TileGridView *tileGridView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tileGridView = [[TileGridView alloc] initWithTileFileName:@"Chimes"];
    [self.view addSubview:_tileGridView];
    _tileGridView.frame = [UIScreen mainScreen].bounds;
    _animatedView = [[AnimatedULogoView alloc] initWithFrame:CGRectMake(0, 0, 90, 90)];
    [self.view addSubview:_animatedView];
    _animatedView.layer.position = self.view.layer.position;
    self.view.backgroundColor = UberBlue;
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_tileGridView startAnimating];
    [_animatedView startAniamting];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
