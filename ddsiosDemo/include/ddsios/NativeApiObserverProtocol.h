/*!
 
 @header NativeApiObserverProtocol.h
 
 @brief This is the protocol file .
 
 @author aispeech
 
 @copyright  2018 aispeech. All rights reserved.
 
 @version   1.0.2.1
 
 */

#import <Foundation/Foundation.h>

/*!
 NativeApiObserverProtocol 协议说明
 */
@protocol AINativeApiDelegate <NSObject>

@required
/*!
 订阅native消息的回调
 
 @param nativeApi 订阅的topic
 @param data 返回的数据
 */
-(void)onQuery:(NSString *)nativeApi data:(NSString *)data;

@end

