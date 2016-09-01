//
//  TitleView.h
//  Uber_Lacunch_OC
//
//  Created by Durand on 16/9/2.
//  Copyright © 2016年 com.Durand. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleView : UIView
@property (nonatomic,strong) UIImage *chimesSplashImage;
@property (nonatomic,strong) NSArray *rippleAnimationKeyTimes;
@property (nonatomic,assign) BOOL shouldEnableRipple;


- (instancetype)initWithTitleFileName:(NSString *)fileName;

- (void)startAnimatingWithDuration:(NSTimeInterval)duration
                         beginTime:(NSTimeInterval)beginTime
                       rippleDelay:(NSTimeInterval)rippleDelay
                      rippleOffset:(CGPoint)rippleOffset;

- (void)stopAnimating;
@end
