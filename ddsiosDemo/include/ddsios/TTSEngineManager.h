
/*!
 
 @header TTSEngineManager.h
 
 @brief This is the interface file .
 
 @author aispeech
 
 @copyright  2018 aispeech. All rights reserved.
 
 @version   1.0.2.1
 
 */

#import <Foundation/Foundation.h>
#import "TTSEngineManagerProtocol.h"


/*!
 TTSEngineManager接口说明
 */
@interface TTSEngineManager : NSObject

/*!
 设置TTSEngineManager委托

 @param delegate 委托对象
 */
-(void)setTTSEngienManagerDelegate:(id<TTSEngineManagerProtocol>) delegate;

/*!
 播报文本。当K_TTS_MODE设置为"external"时，或者在对话过程中，该接口无效，请直接调用外部TTS引擎的对应接口。
 
 @param text 播报文本
 @param priority 优先级,优先级0-保留，与aios语音交互同级，仅限内部使用;优先级1-正常，默认选项，同级按序播放;优先级2-重要，可以打断优先级1，同级按序播放，播报完毕后继续播报优先级1;优先级3-紧急，可以打断优先级1或优先级2，同级按序播放，播报完毕后播报下一句优先
 @param ttsId 用于追踪该次播报的id，建议使用UUID.
 */
-(void) speak:(NSString*)text priority:(int)priority ttsId:(NSString*)ttsId;

/*!
 播报文本，支持SSML。当K_TTS_MODE设置为"external"时，或者在对话过程中，该接口无效，请直接调用外部TTS引擎的对应接口,本地合成不支持SSML。
 
 @param text 播报文本
 @param priority 优先级,优先级0-保留，与aios语音交互同级，仅限内部使用;优先级1-正常，默认选项，同级按序播放;优先级2-重要，可以打断优先级1，同级按序播放，播报完毕后继续播报优先级1;优先级3-紧急，可以打断优先级1或优先级2，同级按序播放，播报完毕后播报下一句优先
 @param ttsId 用于追踪该次播报的id，建议使用UUID.
 @param type 播报的文本类型
 */
-(void) speak:(NSString*)text priority:(int)priority ttsId:(NSString*)ttsId type:(NSString*) type;

/*!
 停止播报接口.当K_TTS_MODE设置为"external"时，该接口无效，请直接调用外部TTS引擎的对应接口。
 
 @param ttsId 和ttsId与speak接口的ttsId一致，则停止或者移除该播报;ttsId为all，停止所有播报。
 */
-(void) shutup:(NSString*)ttsId;

/*!
 设置TTS播报类型的接口,调用此接口则云端配置的合成音类型失效，此后的合成音类型都将由此接口来托管
 
 @param speaker 取值如：zhilingf, gdgm等
 */
-(void)setSpeaker:(NSString*)speaker;

/**
 * 设置TTS播报类型的接口
 * 调用此接口则云端配置的合成音类型失效，此后的合成音类型都将由此接口来托管
 * @param speaker 取值如：zhilingf, gdgm等
 * @param resPath 合成资源的全路径: xxx/xxx/gdgm.bin
 */
-(void)setSpeaker:(NSString*)speaker withResPath:(NSString *)resPath;

/*!
 设置TTS播报音量的接口,调用此接口则云端配置的合成音音量失效，此后的合成音音量都将由此接口来托管
 
 @param volume 音量大小，取值1-100
 */
-(void)setVolume:(int)volume;

/*!
 设置TTS播报语速的接口,调用此接口则云端配置的合成音语速失效，此后的合成音语速都将由此接口来托管
 
 @param speed 语速，取值0.5-2.0，0.5语速最快，2.0语速最慢
 */
-(void)setSpeed:(float)speed;

/*!
 获取当前使用的合成音类型
 
 @return 当前使用的合成音类型,如："zhilingf",获取失败返回nil
 */
-(NSString*) getSpeaker;

/*!
 获取当前使用的合成音语速
 
 @return 当前合成音语速，返回值0.5-2.0，0.5语速最快，2.0语速最慢，获取失败返回 0
 */
-(float) getSpeed;

/*!
 获取当前使用的合成音音量
 
 @return 当前合成音音量,返回值1-100,获取失败返回 0
 */
-(int) getVolume;

/*!
 暂停播报
 */
-(void)pausePlayer;

/*!
 恢复播报
 */
-(void)resetPlayer;

/*!
 启动播放器
 */
-(void)startPlayer;
/*!
 停止播放器
 */
-(void)stopPlayer;


/*!
 释放TTSEngineManager单例
 */
+(void)deallocInstance;

/*!
 设置TTS模式
 
 @param mode 取值0 local TTS；取值1 cloud TTS
 */
-(void)setmode:(int)mode;


/**
 清空停止播放器   重设音频策略时调用
 */
- (void)clearPlayer;


/**
 * 设置自定义TTS播报录音的接口
 * 调用此接口则表态配置的播报录音失效,以动态设置的为准
 *
 * @param customAudioList 取值如：自定义播报音频列表
 */

- (void)setCustomAudio:(NSArray *)customAudioList;

/**
 * 获取自定义TTS播报录音的接口
 * @return 自定义TTS播报录音
 */
- (NSArray *)getCustomAudio;


/**
 设置音频策略改变是否清空播放队列
 
 @param param YES 清空  NO 不清空
 */
+(void)setCategorychangeClearQueue:(BOOL)param;


/**
 获取音频策略改变是否清空播放队列
 
 @return YES 清空  NO 不清空
 */
+(BOOL)getCategorychangeClearQueue;


/**
 设置音频打断是否停止播放
 
 @param param YES 停止  NO 不停止
 */
+ (void)setAudioSessionInterruptionStopPlay:(BOOL)param;


/**
 获取音频策略改变是否清空播放队列
 
 @return YES 停止  NO 不停止
 */
+ (BOOL)getAudioSessionInterruptionStopPlay;

@end
