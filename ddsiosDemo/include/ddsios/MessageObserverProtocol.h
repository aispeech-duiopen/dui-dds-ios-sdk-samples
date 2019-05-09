/*!
 
 @header MessageObserverProtocol.h
 
 @brief This is the protocol file .
 
 @author aispeech
 
 @copyright  2018 aispeech. All rights reserved.
 
 @version   1.0.2.1
 
 */


#import <Foundation/Foundation.h>

/*!
 MessageObserverProtocol 协议说明
 */
@protocol AIMessageDelegate <NSObject>
@required
/*!
 订阅message消息的回调
 
 @param message 订阅的topic
 @param data 返回的数据
 */
-(void)onMessage:(NSString *)message  data:(NSString *)data;

@optional
/*!
 截取音频
 
 @param message 音频的topic
 @param data 返回的音频
 */
-(void)onMessageRecorder:(NSString *)message  data:(NSData *)data;
@end

