
/*!
 
 @header TTSEngineManagerProtocol.h
 
 @brief This is the protocol file .
 
 @author aispeech
 
 @copyright  2018 aispeech. All rights reserved.
 
 @version   1.0.2.1
 
 */


#import <Foundation/Foundation.h>

/*!
 DDSManagerProtocol协议说明
 */
@protocol TTSEngineManagerProtocol <NSObject>

/*!
 开始合成时的回调

 @param ttsId 当前TTS的id， 对话过程中的播报ttsid默认为0，通过speak接口调用的播报，ttsid由speak接口指定。
 */
-(void) TTSBeginning:(NSString*)ttsId;

/*!
 合成的音频数据的回调，可能会返回多次，data长度为0表示音频结束

 @param data 音频数据
 */
-(void) TTSReceived:(NSData*)data;

/*!
 TTS播报完成的回调

 @param ttsId 当前TTS的id，对话过程中的播报ttsid默认为0，通过speak接口调用的播报，ttsid由speak接口指定。
 @param status 播报结束的状态;正常播报结束为0;播报中途被打断结束为1
 */
-(void) TTSEnd:(NSString*)ttsId status:(int)status;

/*!
 合成过程中出现错误的回调

 @param error 错误信息
 */
-(void) TTSError:(NSString*) error;

@end
