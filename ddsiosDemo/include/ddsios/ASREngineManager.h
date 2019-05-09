
/*!
 
 @header ASREngineManager.h
 
 @brief This is the interface file .
 
 @author aispeech
 
 @copyright  2018 aispeech. All rights reserved.
 
 @version   1.0.2.1
 
 */

#import <Foundation/Foundation.h>
#import "ASREngineManagerProtocol.h"

/*!
 ASREngineManager接口说明
 */
@interface ASREngineManager : NSObject

/*!
 主动开始识别
 
 调用后直接进入识别，识别结果通过ASREngineManagerDelegate返回。
 
 若当前正在对话中，会先结束当前对话，再开启识别。
 
 若产品开启VAD，用户结束说话之后会自动结束识别，无须调用stopListening
 
 @param delegate 设置ASREngineManager委托，识别结束或取消后，将被清除
 */
-(void) startListening:(id<ASREngineManagerDelegate>)delegate ;

/*!
 主动结束识别,调用后，最终识别结果会通过ASRFinalResults回调返回，然后ASRDelegate将会被清除。
 */
-(void) stopListening;

/*!
 取消此次识别,调用后，ASRDelegate将会被清除，并不再触发任何回调。
 */
-(void) cancel;

/*!
 允许使用ASR
 */
-(void)enable;

/*!
 禁止使用ASR
 */
-(void)disable;

/*!
 获取当前ASR开关状态
 
 @return YES-开启；NO-关闭
 */
-(BOOL) isASREnable;

@end
