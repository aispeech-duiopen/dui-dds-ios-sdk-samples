//
//  WebWidget.h
//  ddsios
//
//  Created by aispeech009 on 12/10/2017.
//  Copyright © 2017 speech. All rights reserved.
//

/*!
 
 @header WebWidget.h
 
 @brief This is the interface file .
 
 @author aispeech
 
 @copyright  2017 aispeech. All rights reserved.
 
 @version   1.0.2.1
 
 */

#import "DuiWidget.h"
#import "ContentWidget.h"


/*!
 接口说明
*/
@interface WebWidget : DuiWidget


/*!
  设置url地址
  @param url url地址
  @return WebWidget WebWidget实例
*/
-(WebWidget*) setUrl:(NSString*) url;


/*!
  增加自定义参数的k,v对
  @param key 键
  @param value 值
  @return WebWidget WebWidget实例
*/
-(WebWidget*) addExtra:(NSString*)key Value:(NSString*)value;
@end
