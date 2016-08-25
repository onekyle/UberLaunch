//
//  AnimatedULogoView.m
//  Uber_Lacunch_OC
//
//  Created by Durand on 22/8/16.
//  Copyright © 2016年 com.Durand. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "AnimatedULogoView.h"
#import "Contans.h"

@interface AnimatedULogoView ()
{
    CGFloat _radius;
    CGFloat _squareLayerLength;
    CGFloat _startTimeOffset;
    CFTimeInterval _beginTime;
}

@property (nonatomic,strong) CAShapeLayer *circleLayer;
@property (nonatomic,strong) CAShapeLayer *lineLayer;
@property (nonatomic,strong) CAShapeLayer *squareLayer;
@property (nonatomic,strong) CAShapeLayer *maskLayer;

@property (nonatomic,strong) CAMediaTimingFunction *strokeEndTimingFunction;
@property (nonatomic,strong) CAMediaTimingFunction *circleLayerTimingFunction;

@end

@implementation AnimatedULogoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _radius = 37.0;
        _squareLayerLength = 21.0;
        _startTimeOffset = 0.7 * kAnimationDuration;
        _beginTime = 0;
        
        _circleLayer = [self generateCircleLayer];
        _lineLayer = [self generateLineLayer];
        
        [self.layer addSublayer:_circleLayer];
        [self.layer addSublayer:_lineLayer];
    }
    return self;
}

-(void)startAniamting
{
    _beginTime = CACurrentMediaTime();
    self.layer.anchorPoint = CGPointZero;
    [self animateCircleLayer];
    [self animateLineLayer];
}


-(void) animateCircleLayer
{
    // strokeEnd
    CAKeyframeAnimation *strokeEndAnimation = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnimation.timingFunction = self.strokeEndTimingFunction;
    strokeEndAnimation.duration = kAnimationDuration - kAnimationDurationDelay;
    strokeEndAnimation.values = @[@(0.0),@(1.0)];
    strokeEndAnimation.keyTimes = @[@(0.0),@(1.0)];
    
    // transform
    CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    transformAnimation.timingFunction = self.strokeEndTimingFunction;
    transformAnimation.duration = kAnimationDuration - kAnimationDurationDelay;
    
    CATransform3D startingTransform = CATransform3DMakeRotation((CGFloat)-M_PI_4, 0, 0, 1);
    startingTransform = CATransform3DScale(startingTransform, 0.25, 0.25, 1);
    transformAnimation.fromValue = [NSValue valueWithCATransform3D:startingTransform];
    transformAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)];
    
    // Group
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = @[strokeEndAnimation, transformAnimation];
    groupAnimation.repeatCount = MAXFLOAT;
    groupAnimation.duration = kAnimationDuration;
    groupAnimation.beginTime = _beginTime;
    groupAnimation.timeOffset = _startTimeOffset;
    
    [_circleLayer addAnimation:groupAnimation forKey:@"looping"];
}

-(void) animateLineLayer
{
    // lineWidth
    CAKeyframeAnimation *lineWidthAnimation = [CAKeyframeAnimation animationWithKeyPath:@"lineWidth"];
    lineWidthAnimation.values = @[@(0.0),@(5.0),@(0.0)];
    lineWidthAnimation.timingFunctions = @[self.strokeEndTimingFunction, self.circleLayerTimingFunction];
    lineWidthAnimation.duration = kAnimationDuration;
    lineWidthAnimation.keyTimes = @[@(0.0),@((kAnimationDuration - kAnimationDurationDelay) / kAnimationDuration),@(1.0)];
    // transform
    CAKeyframeAnimation *transformAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    transformAnimation.timingFunctions = @[self.strokeEndTimingFunction,self.circleLayerTimingFunction];
    transformAnimation.duration = kAnimationDuration;
    transformAnimation.keyTimes = @[@(0.0),@((kAnimationDuration - kAnimationDurationDelay) / kAnimationDuration),@(1.0)];
    CATransform3D transform = CATransform3DMakeRotation((CGFloat)(7.0 * M_PI_4), 0.0, 0.0, 1.0);
    transformAnimation.values = @[[NSValue valueWithCATransform3D:transform],[NSValue valueWithCATransform3D:CATransform3DIdentity],[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.15, 0.15, 1.0)]];
    
    // Group
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.repeatCount = MAXFLOAT;
    groupAnimation.removedOnCompletion = NO;
    groupAnimation.duration = kAnimationDuration;
    groupAnimation.beginTime = _beginTime;
    groupAnimation.animations = @[lineWidthAnimation, transformAnimation];
    groupAnimation.timeOffset = _startTimeOffset;
    [_lineLayer addAnimation:groupAnimation forKey:@"looping"];
}


-(CAShapeLayer *)generateCircleLayer
{
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.lineWidth = _radius;
    layer.path = [UIBezierPath bezierPathWithArcCenter:CGPointZero radius:_radius/2 startAngle:(CGFloat)-M_PI_2 endAngle:(CGFloat)(3 * M_PI_2) clockwise:YES].CGPath;
    layer.strokeColor = [UIColor whiteColor].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    return layer;
}

-(CAShapeLayer *)generateLineLayer
{
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.position = CGPointZero;
    layer.frame = CGRectZero;
    layer.allowsGroupOpacity = YES;
    layer.lineWidth = 5.0;
    layer.strokeColor = UberBlue.CGColor;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointZero];
    [bezierPath addLineToPoint:CGPointMake(0.0, -_radius)];
    
    layer.path = bezierPath.CGPath;
    return layer;
}

-(CAMediaTimingFunction *)strokeEndTimingFunction
{
    if (!_strokeEndTimingFunction) {
        _strokeEndTimingFunction = [[CAMediaTimingFunction alloc] initWithControlPoints:1.00 :0.0 :0.35 :1.0];
}
    return _strokeEndTimingFunction;
}

-(CAMediaTimingFunction *)circleLayerTimingFunction
{
    if (!_circleLayerTimingFunction) {
        _circleLayerTimingFunction = [[CAMediaTimingFunction alloc] initWithControlPoints:0.65 :0.0 :0.40 :1.0];
    }
    return _circleLayerTimingFunction;
}

@end
