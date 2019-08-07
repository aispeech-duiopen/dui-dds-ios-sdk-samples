
/*!
 @header DDSManager.h
 
 @brief This is the interface file .
 
 @author aispeech
 
 @copyright  2017 aispeech. All rights reserved.
 
 @version   1.0.2.1
 */

#import <Foundation/Foundation.h>
#import "ASREngineManager.h"
#import "TTSEngineManager.h"
#import "DDSManagerProtocol.h"
#import "NativeApiObserverProtocol.h"
#import "CommandObserverProtocol.h"
#import "MessageObserverProtocol.h"
#import "DDSWakeupEngineManager.h"
#import "AIUpdateContextIntent.h"
#import "DDSAuthInfo.h"

/*!
 DDSManager 接口说明
*/
@interface DDSManager : NSObject

/*!
 DDSManager 委托对象
*/
@property(nonatomic,weak) id<DDSManagerDelegate>delegate;

/*!
 创建SDK实例
*/
+(DDSManager *) shareInstance;

/*!
 销毁sdk实例
*/
+(void)deallocInstance;

/*!
 获取sdk实例

 @return DDSManager
*/

+(DDSManager *) getInstance;

/*!
 设置是否在控制台输出sdk的log信息, 默认NO(不输出log)

 @param value 设置为YES, SDK 会输出log信息可供调试参考. 除非特殊需要，否则发布产品时需改回NO.
*/
+ (void)setLogEnabled:(BOOL)value;

/*!
 设置是否将sdk的log信息写入文件, 默认NO(不写入)
 
 @param value 设置为YES, SDK 会写入log信息到文件SDKLog.log可供调试参考. 除非特殊需要，否则发布产品时需改回NO.
 */
+ (void)setLogWriteToFile:(BOOL)value;


/*!
 初始化

 @param delegate DDSManagerDelegate
 @param params 基本参数，用户可以使用该接口初始化
*/
-(void)startWithdelegate:(id<DDSManagerDelegate>)delegate DDSConfig:(NSDictionary *)params;

/*!
 初始化

 @param delegate DDSManagerDelegate
 @param params 基本参数
 @param serverType 服务类型，取值为2，线上环境，即为用户环境
 */
-(void)startWithdelegate:(id<DDSManagerDelegate>)delegate DDSConfig:(NSDictionary *)params withConfigServerType:(int)serverType;

/*!
 @param array 订阅topic数组
 @param observer 当订阅的topic被触发了，会通知到messageObserver
*/
-(void)subscribe:(NSArray *)array observer:(id)observer;

/*!
  注销Observer. 注销后，这个observer将不再会接受消息
  @param observer observer
*/
-(void)unSubscribe:(id)observer;

/*!
 开启语音唤醒
*/
-(void)enableWakeup NS_DEPRECATED_IOS(7_0, 8_0);

/*!
 关闭语音唤醒
*/
-(void)disableWakeup NS_DEPRECATED_IOS(7_0, 8_0);

/*!
  获取当前的唤醒词
 
  @return NSMutableArray 唤醒词数组
*/
-(NSMutableArray *)getWakeupWords NS_DEPRECATED_IOS(7_0, 8_0);

/*!
  停止当前对话，包括停止合成，取消识别等
*/
-(void)stopDialog;

/*!
  开启新对话,播报提示音后进入识别。若当前正在对话中，会先结束当前对话，再开启新对话。
*/
-(void)startDialog;

/*!
 点击唤醒/停止识别/打断播报
*/
-(void)avatarClick;

/*!
 点击唤醒/停止识别/打断播报 操作接口
 
 @param greeting 在唤醒时附带一则欢迎语
 */
-(void) avatarClick:(NSString*)greeting;


/*!
 按下按键接口
*/
-(void)avatarPress;

/*!
 释放按键接口
*/
-(void)avatarRelease;

/*!
  播报文本，支持SSML,当K_TTS_MODE设置为"external"时，或者在对话过程中，该接口无效，请直接调用外部TTS引擎的对应接口。
 
  @param text       播报文本
  @param priority   优先级
                    优先级1-正常，默认选项，同级按序播放；
                    优先级2-重要，可以打断优先级1，同级按序播放；
                    优先级3-紧急，可以打断优先级1或优先级2，setVolume同级按序播放 *
  @param ttsId      用于追踪该次播报的id，建议使用UUID.
*/
-(void)speak:(NSString *)text  priority:(int )priority ttsId:(NSString *)ttsId NS_DEPRECATED_IOS(7_0, 8_0);

/*!
  停止播报接口,当K_TTS_MODE设置为"external"时，该接口无效，请直接调用外部TTS引擎的对应接口。

  @param ttsId
         ttsId与speak接口的ttsId一致，则停止或者移除该播报;
         ttsId为all， 停止所有播报;
*/
-(void)shutup:(NSString *)ttsId NS_DEPRECATED_IOS(7_0, 8_0);

/*!
  获取资源包中H5资源的路径
 
  @return NSString H5资源index.html的路径
*/
- (NSString *)getValidH5Path;

/*!
 更新
*/
-(void)update;

/*!
 断开连接，释放SDK
*/
-(void)stop;

/*!
  外部TTS播报结束通知接口;
  播放完毕后，需要调用该接口才能自动进入下一轮识别;
  需要将K_TTS_MODE设置为"external"，该接口才会生效
*/
-(void)notifyTTSEnd;

/*!
  反馈native api的执行结果
 
  @param nativeApi dui平台上技能定义的nativeapi
  @param duiWidget duiwidget实例
*/
-(void)feedbackNativeApiResult:(NSString*)nativeApi duiWidget:(id)duiWidget;

/*!
  外部录音机拾音接口,送Pcm音频, 需要将K_RECORDER_MODE设置为"external"，该接口才会生效
 
  @param pcm 音频数据
*/
-(void)feedPcm:(NSData*)pcm;

/*!
 外部录音机,送Ogg音频, 需要将K_RECORDER_MODE设置为"external"，该接口才会生效

 @param oggData 音频数据
 */
-(void)feedOgg:(NSData*)oggData;

/*!
 外部录音机,送Opus音频, 需要将K_RECORDER_MODE设置为"external"，该接口才会生效
 
 @param opus 音频数据
 */
-(void)feedOpus:(NSData*)opus;

/*!
 外部录音机,送Sbc音频, 需要将K_RECORDER_MODE设置为"external"，该接口才会生效

 @param sbc 音频数据
 */
-(void)feedSbc:(NSData *)sbc;

/*!
  设置场景模式
  TTS场景: 静音模式，所有TTS播报将会被静音。
  TTS场景: 正常模式，所有TTS播报将会正常播放。默认值。
  @param ModeBool 取值为0 （静音模式）
                  取值为1 （正常模式）
*/
-(void)setDDSMode:(int)ModeBool;

/*!
 主动触发意图的接口
 
 @param skill 技能名称， 必填
 @param task 任务名称， 必填
 @param intent 意图名称， 必填
 @param slots 语义槽， key-value dictionary， 可选
*/
-(void) triggerIntent:(NSString*) skill task:(NSString*)task intent:(NSString*)intent slots:(NSMutableDictionary*)slots;

/*!
  更新词库接口
  更新指定词库的词条,更新结果可以通过sys.upload.result消息来获取
 
  @param vocabName 需要更新的词库名
  @param contents 需要更新的词条列表
  @param addOrDelete 新增词条还是删除词条
  @return 请求ID，用于追踪sys.upload.result
*/
-(NSString*)updateVocab:(NSString*) vocabName contents:(NSMutableArray*)contents addOrDelete:(BOOL) addOrDelete;

/*!
  更新副唤醒词的接口
  支持设置一个副唤醒词，重复调用会以最新的副唤醒词为准。
 
  @param word 副唤醒词（必须）
  @param pinyin 副唤醒词的拼音
  @param threshold 副唤醒词的阈值
  @param greetings 副唤醒词的欢迎语
*/
-(void) updateMinorWakeupWord:(NSString*) word pinyin:(NSString*) pinyin threshold:(NSString*)threshold greetings:(NSMutableArray*)greetings NS_DEPRECATED_IOS(7_0, 8_0);

/*!
  获取当前的副唤醒词
 
  @return NSString 副唤醒词, 若无则返回nil
*/
-(NSString*)getMinorWakeupWord NS_DEPRECATED_IOS(7_0, 8_0);

/*!
 清空打断唤醒词
 */
-(void) clearShortCutWakeupWord NS_DEPRECATED_IOS(7_0, 8_0);

/*!
 更新打断唤醒词的接口,这类唤醒词能打断正在播报的语音并且将唤醒词送入识别
 
 支持设置多个打断唤醒词，所以参数为数组，重复调用会以最新的打断唤醒词数组为准。
 
 @param words 打断唤醒词, 为NSString数组, 必须
 @param pinyin 打断唤醒词的拼音, 形如：ni hao xiao chi, 为NSString数组, 必须
 @param threshold 打断唤醒词的阈值, 形如：0.120(取值范围：0-1) 为NString数组, 必须
 */
-(void)updateShortcutWakeupWord:(NSMutableArray<NSString*>*)words pinyin:(NSMutableArray<NSString*>*)pinyin threshold:(NSMutableArray<NSString*>*)threshold NS_DEPRECATED_IOS(7_0, 8_0);

/*!
 添加新的打断唤醒词，且不会覆盖之前的唤醒词
 
 @param words 打断唤醒词的汉字（必须）
 @param pinyin 打断唤醒词的拼音（必须）
 @param threshold 打断唤醒词的阈值（必须）
 */
-(void)addShortcutWakeupWord:(NSMutableArray<NSString*>*)words pinyin:(NSMutableArray<NSString*>*)pinyin threshold:(NSMutableArray<NSString*>*)threshold NS_DEPRECATED_IOS(7_0, 8_0);

/*!
 移除指定的打断唤醒词
 
 @param words 打断唤醒词的汉字（必须）
 */
-(void)removeShortcutWakeupWord:(NSMutableArray<NSString*>*)words NS_DEPRECATED_IOS(7_0, 8_0);

/*!
 授权失败，可调用此接口，重启授权
 */
-(void)startAuth;

/*!
 更新命令唤醒词的接口，这类唤醒词会在唤醒之后执行一条指令，不能打断正在播报的语音,支持设置多个命令唤醒词，所以参数为数组，重复调用会以最新的命令唤醒词数组为准
 
 @param actions 命令唤醒词对应的command命令（必须）
 @param words 命令唤醒词的汉字（必须）
 @param pinyin 命令唤醒词的拼音（必须）
 @param threshold 命令唤醒词的阈值（必须）
 @param greetings  命令唤醒词对应的唤醒语，一个唤醒词可以设置多条欢迎语，所以参数为二维数组，如果想要某个唤醒词不要欢迎语，那么该第二维数组的string可以设置为空字符串""
 */
-(void) updateCommandWakeupWord:(NSMutableArray<NSString*>*)actions words:(NSMutableArray<NSString*>*)words pinyin:(NSMutableArray<NSString*>*)pinyin threshold:(NSMutableArray<NSString*>*)threshold greetings:(NSMutableArray<NSMutableArray<NSString*>*>*) greetings NS_DEPRECATED_IOS(7_0, 8_0);

/*!
 清空命令唤醒词
 */
-(void)clearCommandWakeupWord NS_DEPRECATED_IOS(7_0, 8_0);

/*!
 添加命令唤醒词，且不会覆盖之前的命令唤醒词
 
 @param actions 命令唤醒词对应的command命令（必须)
 @param words 命令唤醒词的汉字（必须）
 @param pinyin 命令唤醒词的拼音（必须）
 @param threshold  命令唤醒词的阈值（必须)
 @param greetings 命令唤醒词对应的唤醒语，一个唤醒词可以设置多条欢迎语，所以参数为二维数组，如果想要某个唤醒词不要欢迎语，那么该第二维数组的string可以设置为空字符串""
 */
-(void) addCommandWakeupWord:(NSMutableArray<NSString*>*)actions words:(NSMutableArray<NSString*>*)words pinyin:(NSMutableArray<NSString*>*)pinyin threshold:(NSMutableArray<NSString*>*)threshold greetings:(NSMutableArray<NSMutableArray<NSString*>*>*)greetings NS_DEPRECATED_IOS(7_0, 8_0);

/*!
 移除指定的命令唤醒词
 
 @param words 命令唤醒词的汉字（必须）
 */
-(void)removeCommandWakeupWord:(NSMutableArray<NSString*>*)words NS_DEPRECATED_IOS(7_0, 8_0);

/*!
 如果您期望跳过识别直接输入文本进行对话，可以在需要的时候调用下面的接口。
 若当前没有在对话中，则以文本作为首轮说法，新发起一轮对话请求。
 若当前正在对话中，则跳过识别，直接发送文本。
 
 @param text 输入的文本内容
 */
-(void) sendText:(NSString*)text;

/*!
 发送topic

 @param topic 发送订阅的topic
 @param list 须要发送的数据
 */
-(void)publishTopic:(NSString *)topic list:(NSMutableArray<NSString*>*)list;

/*!
 rpc调用
 
 @param url rpc Url
 @param list rcp调用参数
 @return 返回数据
 */
-(NSMutableArray*)rpcURL:(NSString *)url list:(NSMutableArray<NSString*>*)list;

/*!
 获取VAD后端停顿时间的接口
 
 @return 后端停顿时间，单位为毫秒
 */
-(long) getVadPauseTime;

/*!
 设置VAD后端停顿时间的接口。若VAD在用户说话时停顿超过一定的时间，则认为用户已经说完，发出sys.vad.end消息，结束录音。
 
 @param millis 后端停顿时间，单位为毫秒。默认值为500毫秒。
 @return YES-设置成功；NO-设置失败
 */
-(BOOL) setVadPauseTime:(long)millis;

/*!
 返回ASREngineManager实例
 
 @return 返回实例
 */
-(ASREngineManager*)getASRInstance;

/*!
 更新设备状态，用来保存设备的一些状态，比如：蓝牙是否打开,上传结果可以通过sys.upload.result消息来获取
 
 @param deviceInfo 设备状态信息，例如：@{@"bluetooth":@{@"state":@"disconnected"}},在技能中使用$context.bluetooth.state$将会获取到返回值"disconnected"
 @return 请求ID，用于追踪sys.upload.result
 */
-(NSString*)updateDeviceInfo:(NSMutableDictionary<NSString*, NSMutableDictionary*>*)deviceInfo;

/*!
 获取客户端保存的设备信息
 
 @return 设备信息的jsonString，例如：{"bluetooth":"disconnected"}
 */
-(NSString*) getDeviceInfo;


/*!
 返回TTSEngine实例
 
 @return 返回实例
 */
-(TTSEngineManager*)getTTSInstance;


/*!
 返回DDSWakeupEngineManager实例
 
 @return 返回实例
 */
-(DDSWakeupEngineManager *)getDDSWakeupEngineManager;

/**
 打开内置录音机
 */
-(void)startAIRecorder;

/**
 关闭内置录音机
 */
-(void)stopAIRecorder;

/**
 暂停内置录音机
 */
-(void)pauseAIRecorder;

/**
 恢复内置录音机
 */
-(void)resumeAIRecorder;

/*!
 设置对话模式
 
 @param mode 取值：1，本地对话管理；取值2，云端对话管理
 */
- (void)setDialogMode:(int)mode;


/*!
 添加主唤醒词的接口,支持添加多个主唤醒词，调用此接口会覆盖控制台配置的主唤醒词，直到通过removeMainWakeupWord接口移除。
（相同words重复添加无效，如需要改变其他属性，需先移除再重新添加）

 @param words 主唤醒词，不为nil
 @param pinyin 主唤醒词的拼音，不为nil
 @param threshold 主唤醒词的阈值，不为nil
 @param greetings 主唤醒词的欢迎语，不为nil；如果某个唤醒词不想要欢迎语，在对应的维度设为NULL
 */
-(void) addMainWakeupWord:(NSMutableArray<NSString*>*)words pinyin:(NSMutableArray<NSString*>*)pinyin threshold:(NSMutableArray<NSString*>*)threshold greetings:(NSMutableArray<NSMutableArray<NSString*>*>*)greetings NS_DEPRECATED_IOS(7_0, 8_0);

/*!
 移除指定的主唤醒词,如果移除了所有通过addMainWakeupWord接口添加的主唤醒词，则主唤醒词重置为控制台所配置的
 
 @param words 主唤醒词的汉字（必须）
 */
-(void) removeMainWakeupWord:(NSMutableArray<NSString*>*)words NS_DEPRECATED_IOS(7_0, 8_0);


/*!
 更新设备状态，产品级的配置。比如：定位信息，设备硬件状态等
 更新结果可以通过sys.upload.result消息来获取
 
 @param intent 请求的AIUpdateContextIntent对象，包括contextIntentKey和contextIntentValue
 如：contextIntentKey = @"location", contextIntentValue = @{@"city":@"苏州市"}
 技能里通过$context.location.city$即可获取到"苏州市"
 @return 请求的ID，用于追踪sys.upload.result
 */
-(NSString *)updateProductContext:(AIUpdateContextIntent *)intent;


/*!
 更新技能配置，需要调用ContextIntent.setSkillId设置技能ID
 更新结果可以通过sys.upload.result消息来获取
 
 @param intent 请求的AIUpdateContextIntent对象，包括contextIntentKey、contextIntentValue、contextIntentSkillId
 @return 请求的ID，用于追踪sys.upload.result
 */
-(NSString *)updateSkillContext:(AIUpdateContextIntent *)intent;


/*!
 获取产品的配置信息
 
 @param inputKey 配置项名称
 @return 配置项值
 */
-(NSObject *)getProductContext:(NSString*)inputKey;


/*!
 获取技能的配置信息
 
 @param skillId 技能ID
 @param inputKey 配置项名称
 @return 配置项值
 */
-(NSObject *)getSkillContext:(NSString*)skillId key:(NSString*) inputKey;



/*!
 检查更新

 @return 返回json串，例如：
    {
        "product": {
            "productVersion": "xxxxxxx",
            "changelogs": "xxxxxxx",
        },
        "platform": "xxxxxxx",
        "duicore": {
            "duicoreVersion": "xxxxx",
            "changelogs": "xxxxxxxx",
        },
    }
    如果有错，json串，如下：
    {
        "errId":"xxxxxxxxx",
        "error":"xxxxxxxxxx"
    }
 */
-(NSString*)checkUpdate;

/*!
 下载最新版本的资源

 @return 返回json串，若没有更新则为空串，例如：
        {
            "productPath":"xxxxxxxxx/custom-41-full.zip",
            "duicorePath":"xxxxxxxxxx/duicore-4-full.zip"
        }
        如果有错，json串，如下：
        {
            "errId":"xxxxxxxxx",
            "error":"xxxxxxxxxx"
        }
 */
-(NSString*)download;

/*!
 解压缩，与download匹配使用
 */
-(void)decompress;

/**
 使用OAuth授权时用于更新accessToken

 @param accessToken 获取的accessToken
 */
-(BOOL) updateAccessToken:(NSString *)accessToken;


/**
 根据性别更新欢迎语

 @param maleGreetings 男性欢迎语
 @param femaleGreetings 女性欢迎语
 */
-(void)updateGenderGreeting:(NSArray<NSString *> *)maleGreetings And:(NSArray<NSString *> *)femaleGreetings;


@end
