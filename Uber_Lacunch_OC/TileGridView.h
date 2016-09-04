//
//  TileGridView.h
//  Uber_Lacunch_OC
//
//  Created by Durand on 3/9/16.
//  Copyright © 2016年 com.Durand. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TileGridView : UIView
-(instancetype)initWithTileFileName:(NSString *)name;
- (void)startAnimating;
@end
