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
@property (nonatomic,strong) CAMediaTimingFunction *squareLayerTimingFunction;
@property (nonatomic,strong) CAMediaTimingFunction *fadeInSquareTimingFunction;

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
        _squareLayer = [self generateSquareLayer];
        _maskLayer = [self generateMaskLayer];
        
        self.layer.mask = _maskLayer;
        [self.layer addSublayer:_circleLayer];
        [self.layer addSublayer:_lineLayer];
        [self.layer addSublayer:_squareLayer];
    }
    return self;
}

-(void)startAniamting
{
    _beginTime = CACurrentMediaTime();
    self.layer.anchorPoint = CGPointZero;
    [self animateMaskLayer];
    [self animateCircleLayer];
    [self animateLineLayer];
    [self animateSquareLayer];
}

-(void) animateMaskLayer
{
    // bounds
    CABasicAnimation *boundsAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    boundsAnimation.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, _radius * 2, _radius * 2)];
    boundsAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0,2.0/3.0 * _squareLayerLength, 2.0/3.0 * _squareLayerLength)];
    boundsAnimation.duration = kAnimationDurationDelay;
    boundsAnimation.beginTime = kAnimationDuration - kAnimationDurationDelay;
    boundsAnimation.timingFunction = self.circleLayerTimingFunction;
    
    // cornerRadius
    CABasicAnimation *cornerRadiusAnimation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    cornerRadiusAnimation.beginTime = kAnimationDuration - kAnimationDurationDelay;
    cornerRadiusAnimation.duration = kAnimationDurationDelay;
    cornerRadiusAnimation.fromValue = @(_radius);
    cornerRadiusAnimation.toValue = @2;
    cornerRadiusAnimation.timingFunction = self.circleLayerTimingFunction;
    
    // Group
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.removedOnCompletion = NO;
    groupAnimation.fillMode = kCAFillModeBoth;
    groupAnimation.beginTime = _beginTime;
    groupAnimation.repeatCount = MAXFLOAT;
    groupAnimation.duration = kAnimationDuration;
    groupAnimation.animations = @[boundsAnimation, cornerRadiusAnimation];
    groupAnimation.timeOffset = _startTimeOffset;
    [_maskLayer addAnimation:groupAnimation forKey:@"looping"];
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

-(void) animateSquareLayer
{
    // bounds
    NSValue *b1 = [NSValue valueWithCGRect:CGRectMake(0, 0, 2.0/3.0 * _squareLayerLength, 2.0/3.0 * _squareLayerLength)];
    NSValue *b2 = [NSValue valueWithCGRect:CGRectMake(0, 0, _squareLayerLength, _squareLayerLength)];
    NSValue *b3 = [NSValue valueWithCGRect:CGRectZero];
    
    CAKeyframeAnimation *boundsAnimation = [CAKeyframeAnimation animationWithKeyPath:@"bounds"];
    boundsAnimation.values = @[b1, b2, b3];
    boundsAnimation.timingFunctions = @[self.fadeInSquareTimingFunction, self.squareLayerTimingFunction];
    boundsAnimation.duration = kAnimationDuration;
    boundsAnimation.keyTimes = @[@0, @((kAnimationDuration - kAnimationDurationDelay) / kAnimationDuration) , @1];
    
    // backgroundColor
    CABasicAnimation *backgroundColorAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    backgroundColorAnimation.fromValue = (__bridge id _Nullable)([UIColor whiteColor].CGColor);
    backgroundColorAnimation.toValue = (__bridge id _Nullable)(UberBlue.CGColor);
    backgroundColorAnimation.timingFunction = self.squareLayerTimingFunction;
    backgroundColorAnimation.fillMode = kCAFillModeBoth;
    backgroundColorAnimation.beginTime = kAnimationDurationDelay * 2.0 / kAnimationDuration;
    backgroundColorAnimation.duration = kAnimationDuration / (kAnimationDuration - kAnimationDurationDelay);
    
    // Group
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = @[boundsAnimation, backgroundColorAnimation];
    groupAnimation.repeatCount = MAXFLOAT;
    groupAnimation.duration = kAnimationDuration;
    groupAnimation.removedOnCompletion = NO;
    groupAnimation.beginTime = _beginTime;
    groupAnimation.timeOffset = _startTimeOffset;
    [_squareLayer addAnimation:groupAnimation forKey:@"looping"];
}

-(CAShapeLayer *)generateMaskLayer
{
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = CGRectMake(-_radius, -_radius, _radius * 2, _radius * 2);
    layer.allowsGroupOpacity = YES;
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    return layer;
}

-(CAShapeLayer *)generateCircleLayer
{
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.lineWidth = _radius;
    layer.path = [UIBezierPath bezierPathWithArcCenter:CGPointZero radius:_radius/2 startAngle:(CGFloat)-M_PI_2 endAngle:(CGFloat)(3 * M_PI_2) clockwise:YES].CGPath;
    layer.strokeColor = [UIColor whiteColor].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    return layer;
}

-(CAShapeLayer *)generateLineLayer
{
    CAShapeLayer *layer = [CAShapeLayer layer];
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

-(CAShapeLayer *)generateSquareLayer
{
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.position = CGPointZero;
    layer.frame =CGRectMake(-_squareLayerLength / 2, -_squareLayerLength / 2, _squareLayerLength, _squareLayerLength);
    layer.cornerRadius = 1.5;
    layer.allowsGroupOpacity = YES;
    layer.backgroundColor = UberBlue.CGColor;
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

-(CAMediaTimingFunction *)squareLayerTimingFunction
{
    if (!_squareLayerTimingFunction) {
        _squareLayerTimingFunction = [[CAMediaTimingFunction alloc] initWithControlPoints:0.25 :0.0 :0.20 :1.0];
    }
    return _squareLayerTimingFunction;
}

-(CAMediaTimingFunction *)fadeInSquareTimingFunction
{
    if (!_fadeInSquareTimingFunction) {
        _fadeInSquareTimingFunction = [[CAMediaTimingFunction alloc] initWithControlPoints:0.15 :0 :0.85 :1.0];
    }
    return _fadeInSquareTimingFunction;
}

@end
