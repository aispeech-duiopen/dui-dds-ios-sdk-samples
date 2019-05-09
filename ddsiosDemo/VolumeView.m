//
//  VolumeView.m
//  iphone.mobileoa.wzszct
//
//  Created by Pill Gong on 14-3-28.
//  Copyright (c) 2014年 Epoint. All rights reserved.
//

#import "VolumeView.h"
//#import "UIView+Addtions.h"

#define _DEVICE_WINDOW ((UIView*)[UIApplication sharedApplication].keyWindow)

#define VolumeSizeValue 144
#define LeftPadding 20

@interface VolumeView ()

@property (nonatomic, strong) UIImageView *rightImage;
@property (nonatomic, strong) UIImageView *leftImage;
@property (nonatomic, strong) UILabel *noteLabel;
@property (nonatomic, strong) UIImageView *errorImage;

@end

@implementation VolumeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.frame = CGRectMake(0, 0, VolumeSizeValue, VolumeSizeValue);
        self.layer.cornerRadius = 10;
        self.layer.backgroundColor = [[UIColor colorWithWhite:0.1 alpha:0.8] CGColor];
//        self.centerX = UIScreenWidth * 0.5;
//        self.centerY = UIScreenHeight * 0.5;
        self.center = CGPointMake([UIScreen mainScreen].bounds.size.width * 0.5, [UIScreen mainScreen].bounds.size.height * 0.5);
        self.alpha = 0;
        
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews {
    self.leftImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"voice.bundle/mic_image"]];
    _leftImage.frame = CGRectMake(LeftPadding, LeftPadding*0.5, VolumeSizeValue*0.5 - LeftPadding, VolumeSizeValue - LeftPadding*2);
    [self addSubview:_leftImage];
    
    self.rightImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"voice.bundle/RecordingSignal001"]];
    _rightImage.frame = CGRectMake(VolumeSizeValue*0.5+LeftPadding, LeftPadding*0.5, VolumeSizeValue*0.5 - LeftPadding*2, VolumeSizeValue - LeftPadding*2);
    [self addSubview:_rightImage];

//    self.noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _leftImage.bottom + LeftPadding*0.25, VolumeSizeValue, LeftPadding)];
//    _noteLabel.text = MFLocalizedString(Chat_SlideUpToCancel);
    
    _noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, [_leftImage bounds].origin.x + [_leftImage bounds].size.height + LeftPadding*0.75, VolumeSizeValue, LeftPadding)];
    _noteLabel.text = @"正在说话...";
    _noteLabel.textAlignment = NSTextAlignmentCenter;
    _noteLabel.textColor = [UIColor whiteColor];
    _noteLabel.font = [UIFont boldSystemFontOfSize:14];
    _noteLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_noteLabel];
    
    UIImage *errImage = [UIImage imageNamed:@"voice.bundle/voice_too_short"];
    self.errorImage = [[UIImageView alloc] initWithImage:errImage];
    _errorImage.frame = CGRectMake(0, 0, errImage.size.width*0.75, errImage.size.height*0.75);
//    _errorImage.top = LeftPadding*1.25;
//    _errorImage.centerX = VolumeSizeValue*0.5;
    [self addSubview:_errorImage];
}

- (void)show {
    [_DEVICE_WINDOW addSubview:self];
    [self updateVisibleSubview];
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
    }];
}

- (void)showError {
    _leftImage.hidden = YES;
    _rightImage.hidden = YES;
    _errorImage.hidden = NO;
//    _noteLabel.text = MFLocalizedString(Chat_Audio_ToShot);

    [UIView animateWithDuration:0.1 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self hide];
    }];
}

- (void)hide {
    [self removeFromSuperview];
}

- (void)updateVisibleSubview {
    _errorImage.hidden = YES;
    _leftImage.hidden = NO;
    _rightImage.hidden = NO;

//    _noteLabel.text = MFLocalizedString(Chat_SlideUpToCancel);
}

- (void)setProgress:(double)value {
    int count = 8;    
    int index = 0;

    for (int i=count; i>0; i--) {
        if (value >= (i-1)/8.0) {
            index = i;
            break;
        }
    }
    _rightImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"voice.bundle/RecordingSignal00%d", index]];
}

@end
