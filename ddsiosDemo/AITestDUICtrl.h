//
//  AITestDUICtrl.h
//  aios
//
//  Created by speech_dui on 2017/8/21.
//  Copyright © 2017年 yuruilong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DDSManager.h"

typedef void (^assignment)(id object);

@interface AITestDUICtrl : UIViewController<UIWebViewDelegate, AIMessageDelegate, AICommandDelegate, AINativeApiDelegate, DDSManagerDelegate>

@property(nonatomic,strong) NSMutableArray * alarmArray;

- (void)afterInit;

@end
