//
//  MediaWidget.h
//  ddsios
//
//  Created by aispeech009 on 12/10/2017.
//  Copyright © 2017 speech. All rights reserved.
//

/*!
 
 @header MediaWidget.h
 
 @brief This is the interface file .
 
 @author aispeech
 
 @copyright  2017 aispeech. All rights reserved.
 
 @version   1.0.2.1
 
 */

#import "DuiWidget.h"
#import "ContentWidget.h"


/*!
 MediaWidget 接口说明
*/
@interface MediaWidget : DuiWidget

/*!
 增加列表项数据 ContentWidget
 @param widget ContentWidget实例
 @return MediaWidget MediaWidget实例
*/
- (MediaWidget *)addContentWidget:(ContentWidget *)widget;

/*!
  增加自定义参数的k,v对
  @param key 键
  @param value 值
  @return MediaWidget MediaWidget实例
*/
- (MediaWidget *)addExtra:(NSString*) key Value:(NSString *)value;

@end
