//
//  ContentWidget.h
//  ddsios
//
//  Created by hc on 2017/9/30.
//  Copyright © 2017年 speech. All rights reserved.
//

/*!
 
 @header ContentWidget.h
 
 @brief This is the interface file .
 
 @author aispeech
 
 @copyright  2017 aispeech. All rights reserved.
 
 @version   1.0.2.1
 
 */

#import "DuiWidget.h"


/*!
 ContentWidget 接口说明
*/
@interface ContentWidget : DuiWidget

/*!
  设置标题
  @param title title
  @return ContentWidget ContentWidget实例
*/
- (ContentWidget *)setTitle:(NSString *)title;

/*!
  设置副标题
  @param subTitle 副标题
  @return ContentWidget ContentWidget实例
*/
- (ContentWidget *)setSubTitle:(NSString *)subTitle;

/*!
  设置标签数据，建议以 "," 作为分隔
  @param label 标签数据
  @return ContentWidget ContentWidget实例
*/
- (ContentWidget *)setLabel:(NSString *)label;

/*!
  设置图片资源地址
  @param imageUrl 图片资源地址
  @return ContentWidget ContentWidget实例
*/
- (ContentWidget *)setImageUrl:(NSString *)imageUrl;

/*!
  设置跳转地址
  @param linkUrl 跳转地址
  @return ContentWidget ContentWidget实例
*/
- (ContentWidget *)setLinkUrl:(NSString *)linkUrl;

/*!
 增加自定义参数的k,v对

 @param key key 键
 @param value value 值
 @return ContentWidget ContentWidget实例
 */
-(ContentWidget*) addExtra:(NSString*) key Value:(NSString*)value;

@end
