//
//  Contans.h
//  Uber_Lacunch_OC
//
//  Created by Durand on 22/8/16.
//  Copyright © 2016年 com.Durand. All rights reserved.
//

#import <UIKit/UIKit.h>
/// The total animation duration of the splash animation
UIKIT_EXTERN const NSTimeInterval kAnimationDuration;
/// The length of the second part of the duration
UIKIT_EXTERN const NSTimeInterval kAnimationDurationDelay;
/// The offset between the AnimatedULogoView and the background Grid
UIKIT_EXTERN const NSTimeInterval kAnimationTimeOffset;
/// The ripple magnitude. Increase by small amounts for amusement ( <= .2) :]
UIKIT_EXTERN const NSTimeInterval kRippleMagnitudeMultiplier;

#define UberBlue [UIColor colorWithRed:15/255.0 green:78/255.0 blue:101/255.0 alpha:1.0]
#define UberLightBlue [UIColor colorWithRed:77/255.0 green:181/255.0 blue:217/255.0 alpha:1.0]

#define DELAYRUN(t,block) dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(t * NSEC_PER_SEC)), dispatch_get_main_queue(), block)