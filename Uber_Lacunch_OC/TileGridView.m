//
//  TileGridView.m
//  Uber_Lacunch_OC
//
//  Created by Durand on 3/9/16.
//  Copyright © 2016年 com.Durand. All rights reserved.
//

#import "TileView.h"
#import "TileGridView.h"
#import "Contans.h"

@interface TileGridView ()
@property (nonatomic,strong) UIView *containerView;
@property (nonatomic,strong) TileView *modelTileView;
@property (nonatomic,strong) TileView *centerTileView;
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
    _modelTileView = [[TileView alloc] initWithTitleFileName:name];
    self = [super initWithFrame:CGRectZero];
    if (self)
    {
        _numberOfRows = 0;
        _numberOfColumns = 0;
        _beginTime = 0;
        _tileViewRows = [NSMutableArray array];
        _kRippleDelayMultiplier = 0.0006666;
        self.clipsToBounds = YES;
        self.layer.masksToBounds = YES;
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 630, 990)];
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

- (void)startAnimating
{
    _beginTime = CACurrentMediaTime();
    [self startAnimatingWithBeginTime:_beginTime];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    _containerView.center = self.center;
    _modelTileView.center = _containerView.center;
    if (_centerTileView) {
        // Custom offset needed for UILabel font
        CGPoint center = CGPointMake(CGRectGetMidX(_centerTileView.bounds) + 31, CGRectGetMidY(_centerTileView.bounds));
        _logoLabel.center = center;
    }
}

- (UILabel *)generateLogoLabel
{
    UILabel *label = [UILabel new];
    label.text = @"           BER";
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
        NSMutableArray<TileView *> *tileRows = [NSMutableArray array];
        for (int x = 0; x < _numberOfColumns; x++) {
            TileView *view = [[TileView alloc] init];
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

- (void)startAnimatingWithBeginTime:(NSTimeInterval)beginTime
{
    CAMediaTimingFunction *linearTimingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    CAKeyframeAnimation *keyframe = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    keyframe.timingFunctions = @[linearTimingFunction,[[CAMediaTimingFunction alloc] initWithControlPoints:0.6 :0.0 :0.15 :1.0],linearTimingFunction];
    keyframe.repeatCount = MAXFLOAT;
    keyframe.duration = kAnimationDuration;
    keyframe.removedOnCompletion = NO;
    keyframe.keyTimes = @[@0.0, @0.45, @0.887, @1.0];
    keyframe.values = @[@0.75, @0.75, @1.0, @1.0];
    keyframe.beginTime = beginTime;
    
    keyframe.timeOffset = kAnimationTimeOffset;
    
    [_containerView.layer addAnimation:keyframe forKey:@"scale"];
    
    for (NSArray *tileRows in _tileViewRows) {
        for (TileView *view in tileRows) {
            CGFloat distance = [self distanceFromCenterViewWithView:view];
            CGPoint vector = [self normalizedVectorFromCenterViewToView:view];
            
            vector = CGPointMake(vector.x * _kRippleDelayMultiplier * distance, vector.y * _kRippleDelayMultiplier * distance);
            
            [view startAnimatingWithDuration:kAnimationDuration beginTime:beginTime rippleDelay:_kRippleDelayMultiplier * (NSTimeInterval)distance rippleOffset:vector];
        }
    }
}

- (CGFloat)distanceFromCenterViewWithView:(UIView *)view
{
    if (!_centerTileView) {
        return 0;
    }
    
    CGFloat normalizedX = view.center.x - _centerTileView.center.x;
    CGFloat normalizedY = view.center.y - _centerTileView.center.y;
    return sqrt(normalizedX * normalizedX + normalizedY * normalizedY);
}

- (CGPoint)normalizedVectorFromCenterViewToView:(UIView *)view
{
    CGFloat length = [self distanceFromCenterViewWithView:view];
    
    if (!_centerTileView || !length) {
        return CGPointZero;
    }
    
    CGFloat deltaX = view.center.x - _centerTileView.center.x;
    CGFloat deltaY = view.center.y - _centerTileView.center.y;
    return CGPointMake(deltaX / length, deltaY / length);
}

@end
