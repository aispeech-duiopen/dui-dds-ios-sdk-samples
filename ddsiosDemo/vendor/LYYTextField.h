//
//  AITestDUICtrl.h
//  aios
//
//  Created by speech_dui on 2017/10/22.
//  Copyright © 2017年 yuruilong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYYTextField : UITextField
/**高亮状态占位符颜色 默认白色*/
@property (nonatomic, strong) UIColor *placeholderColor;
/**普通模式占位符颜色 默认灰色*/
@property (nonatomic, strong) UIColor *NomalplaceholderColor;

/** 输入完毕后文字是否变灰*/
@property (nonatomic, assign) BOOL changeTextColor;


@end
