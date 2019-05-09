

/*!
 
 @header ASREngineManagerProtocol.h
 
 @brief This is the protocol file .
 
 @author aispeech
 
 @copyright  2018 aispeech. All rights reserved.
 
 @version   1.0.2.1
 
 */

#import <Foundation/Foundation.h>

/*!
 ASREngineManagerDelegate协议说明
 */
@protocol ASREngineManagerDelegate <NSObject>

@optional

/*!
 当用户开始说话时的回调， 产品开启VAD时有效
 */
-(void) ASRBeginningOfSpeech;


/*!
 检测到用户结束说话的回调， 产品开启VAD时有效
 */
-(void) ASREndOfSpeech;


/*!
 采集到音频数据的回调
 
 @param buffer 音频数据
 */
-(void) ASRBufferReceived:(NSData *) buffer;


/*!
 实时识别结果的回调
 
 @param results 实时识别结果
 */
-(void) ASRPartialResults:(NSString *) results;


/*!
 最终识别结果的回调
 
 @param results 最终识别结果
 */
-(void) ASRFinalResults:(NSString *) results;


/*!
 识别过程发生错误的回调
 
 @param error 错误信息
 */
-(void) ASRError:(NSString*) error;


/*!
 音量变化的回调
 
 @param rmsdB 音量大小
 */
-(void) ASRRmsChanged:(float)rmsdB;

@end

