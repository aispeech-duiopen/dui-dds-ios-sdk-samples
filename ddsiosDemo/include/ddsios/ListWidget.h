//
//  ListWidget.h
//  ddsios
//
//  Created by hc on 2017/9/30.
//  Copyright © 2017年 speech. All rights reserved.
//

/*!
 
 @header ListWidget.h
 
 @brief This is the interface file .
 
 @author aispeech
 
 @copyright  2017 aispeech. All rights reserved.
 
 @version   1.0.2.1
 
 */

#import "DuiWidget.h"
#import "ContentWidget.h"


/*!
 ListWidget接口说明
*/
@interface ListWidget : DuiWidget

/*!
  增加列表项数据 ContentWidget
  @param widget ContentWidget实例
  @return ListWidget ListWidget实例
*/
- (ListWidget *)addContentWidget:(ContentWidget *)widget;

/*!
  增加自定义参数的k,v对
  @param key 键
  @param value 值
  @return ListWidget ListWidget实例
*/
- (ListWidget*) addExtra:(NSString*) key Value:(NSString *)value;

@end
