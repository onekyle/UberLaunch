//
//  TileGridView.m
//  Uber_Lacunch_OC
//
//  Created by Durand on 3/9/16.
//  Copyright © 2016年 com.Durand. All rights reserved.
//

#import "TitleView.h"
#import "TileGridView.h"
#import "Contans.h"

@interface TileGridView ()
@property (nonatomic,strong) UIView *containerView;
@property (nonatomic,strong) TitleView *modelTileView;
@property (nonatomic,strong) TitleView *centerTileView;
@property (nonatomic,assign) int numberOfRows;
@property (nonatomic,assign) int numberOfColumns;

@property (nonatomic,strong) UILabel *logoLabel;
@property (nonatomic,strong) NSMutableArray *tileViewRows;
@property (nonatomic,assign) CFTimeInterval beginTime;
@property (nonatomic,assign) NSTimeInterval kRippleDelayMultiplier;
@end

@implementation TileGridView
-(instancetype)initWithTileFileName:(NSString *)name
{
    self = [super initWithFrame:CGRectZero];
    if (self)
    {
        _modelTileView = [[TitleView alloc] initWithTitleFileName:name];
        _tileViewRows = [NSMutableArray array];
        _kRippleDelayMultiplier = 0.0006666;
        self.clipsToBounds = YES;
        self.layer.masksToBounds = YES;
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 630, 999)];
        _containerView.backgroundColor = UberBlue;
        _containerView.clipsToBounds = NO;
        _containerView.layer.masksToBounds = NO;
        [self addSubview:_containerView];
        
        [self renderTileViews];
        
        _logoLabel = [self generateLogoLabel];
        [_centerTileView addSubview:_logoLabel];
        [self layoutIfNeeded];
    }
    return self;
}

- (UILabel *)generateLogoLabel
{
    UILabel *label = [UILabel new];
    label.text = @"         BER";
    label.font = [UIFont systemFontOfSize:50];
    label.textColor = [UIColor whiteColor];
    [label sizeToFit];
    label.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    return label;
}

- (void)renderTileViews
{
    CGFloat width,height,modelImageWidth,modelImageHeight;
    
    width = CGRectGetWidth(_containerView.bounds);
    height = CGRectGetHeight(_containerView.bounds);
    
    modelImageWidth = CGRectGetWidth(_modelTileView.bounds);
    modelImageHeight = CGRectGetHeight(_modelTileView.bounds);
    
    _numberOfColumns = (int)(ceil((width - _modelTileView.bounds.size.width / 2.0) / _modelTileView.bounds.size.width));
    
    _numberOfRows = (int)(ceil((height - _modelTileView.bounds.size.height / 2.0) / _modelTileView.bounds.size.height));
    
    for (int  y = 0; y < _numberOfRows; y++) {
        NSMutableArray<TitleView *> *tileRows = [NSMutableArray array];
        for (int x = 0; x < _numberOfColumns; x++) {
            TitleView *view = [[TitleView alloc] init];
            view.frame = CGRectMake(x * modelImageWidth, y * modelImageHeight, modelImageWidth, modelImageHeight);
            if (CGPointEqualToPoint(view.center, _containerView.center)) {
                _centerTileView = view;
            }
            
            [_containerView addSubview:view];
            [tileRows addObject:view];
            
            if (y && y != _numberOfRows - 1 && x && x != _numberOfColumns) {
                view.shouldEnableRipple = YES;
            }
         }
        
        [_tileViewRows addObject:tileRows];
    }
    
    if (_centerTileView) {
        [_containerView bringSubviewToFront:_centerTileView];
    }
    
}


@end
