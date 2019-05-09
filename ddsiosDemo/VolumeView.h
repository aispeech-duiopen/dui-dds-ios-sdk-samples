//
//  VolumeView.h
//  iphone.mobileoa.wzszct
//
//  Created by Pill Gong on 14-3-28.
//  Copyright (c) 2014年 Epoint. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VolumeView : UIView

- (void)show;
- (void)hide;
- (void)showError;

- (void)setProgress:(double)value;

@end
