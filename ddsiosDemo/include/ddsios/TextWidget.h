//
//  TextWidget.h
//  ddsios
//
//  Created by hc on 2017/9/30.
//  Copyright © 2017年 speech. All rights reserved.
//

/*!
 
 @header TextWidget.h
 
 @brief This is the interface file .
 
 @author aispeech
 
 @copyright  2017 aispeech. All rights reserved.
 
 @version   1.0.2.1
 
 */

#import "DuiWidget.h"


/*!
 TextWidget 接口说明
*/
@interface TextWidget : DuiWidget

/*!
 设置文本

 @param text 文本内容
 @return 返回控件
*/
-(TextWidget *) setText:(NSString*)text;

/*!
 增加自定义参数的k,v对

 @param key 键
 @param value 值
 @return TextWidget TextWidget实例
 */
-(TextWidget*) addExtra:(NSString*) key Value:(NSString*) value;

@end
