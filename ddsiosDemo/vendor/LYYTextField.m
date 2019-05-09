//
//  AITestDUICtrl.h
//  aios
//
//  Created by speech_dui on 2017/10/22.
//  Copyright © 2017年 yuruilong. All rights reserved.
//

#import "LYYTextField.h"
#import <objc/runtime.h>

static NSString *const LYYPlaceholderColorKeyPath  = @"_placeholderLabel.textColor";

@interface LYYTextField ()

/** 保存文字信息*/
@property (nonatomic, strong) UIColor *oldTextColor;

@end

@implementation LYYTextField



-(void)awakeFromNib
{
    //[super awakeFromNib];
    [self setup];
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}



-(void)setup{
    
    //修改光标颜色
    //self.tintColor = self.textColor;
    self.tintColor = [UIColor blackColor];
    //设置默认占位符颜色
    _placeholderColor = [UIColor lightGrayColor];
    //设置普通状态下占位符的颜色
    _NomalplaceholderColor = [UIColor grayColor];
    //保存文字颜色
    self.oldTextColor = self.textColor;
    

    //不成为第一响应者
    [self resignFirstResponder];
    
}

-(BOOL)becomeFirstResponder
{
    [super becomeFirstResponder];
    
    //更改pladeholder字体颜色
    [self setValue:_placeholderColor forKeyPath:LYYPlaceholderColorKeyPath];
    
    //输入完毕后文字是否变灰
    if (self.changeTextColor) {
        
        self.textColor = self.oldTextColor;;
    }

    
    return YES;
}

-(BOOL)resignFirstResponder
{
    [super resignFirstResponder];
    //更改pladeholder字体颜色
    [self setValue:_NomalplaceholderColor forKeyPath:LYYPlaceholderColorKeyPath];
    
    //输入完毕后文字是否变灰
    if (self.changeTextColor) {
        
        self.textColor = [UIColor grayColor];
    }
    
    
    
    return YES;
}

-(void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    
    [self setValue:_placeholderColor forKeyPath:LYYPlaceholderColorKeyPath];
    //不成为第一响应者
    [self resignFirstResponder];
    
}





@end
