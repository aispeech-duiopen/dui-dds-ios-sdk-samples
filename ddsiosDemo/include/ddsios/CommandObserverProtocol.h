/*!
 
 @header CommandObserverProtocol.h
 
 @brief This is the protocol file .
 
 @author aispeech
 
 @copyright  2018 aispeech. All rights reserved.
 
 @version   1.0.2.1
 
 */

#import <Foundation/Foundation.h>

/*!
 CommandObserverProtocol 协议说明
 */
@protocol AICommandDelegate <NSObject>
@required
/*!
 订阅command消息的回调
 
 @param command 订阅的topic
 @param data 返回的数据
 */
-(void)onCall:(NSString *)command data:(NSString *)data;
@end

