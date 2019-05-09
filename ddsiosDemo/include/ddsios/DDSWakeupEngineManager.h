//
//  DDSWakeupEngineManager.h
//  ddsios
//
//  Created by hc on 2018/7/23.
//  Copyright © 2018年 speech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WakeupEngineManagerProtocol.h"

@interface DDSWakeupEngineManager : NSObject

+(instancetype) shareInstance;

+(instancetype) getInstance;

/*!
 释放DDSWakeupEngineManager单例
 */
+(void)deallocInstance;

//注：所有enableXXX均是在enableWakeup的前提下才会生效
//主唤醒词可唤醒
- (void)enableMainWakeupWord;
//主唤醒词不可唤醒
- (void)disableMainWakeupWord;

//副唤醒词可唤醒
- (void)enableMinorWakeupWord;
//副唤醒词不可唤醒
- (void)disableMinorWakeupWord;

//快捷命令唤醒词可唤醒
- (void)enableCommandWakeupWord;
//快捷命令唤醒词不可唤醒
- (void)disableCommandWakeupWord;

//打断唤醒词可唤醒
- (void)enableShortCutWakeupWord;
//打断唤醒词不可唤醒
- (void)disableShortCutWakeupWord;

//识别中开唤醒
-(void) enableWakeupWhenAsr;
//识别中关唤醒
-(void) disableWakeupWhenAsr;

//设置代理
-(void)setWakeupDeletage:(id<WakeupEngineManagerProtocol>) delegate;


/*!
 打开唤醒
 */
-(void)enableWakeup;


/*!
 关闭唤醒
 */
-(void)disableWakeup;


/*!
 获取唤醒词列表

 @return json串
 */
-(NSMutableArray *)getWakeupWords;

/*!
 更新副唤醒词的接口
 支持设置一个副唤醒词，重复调用会以最新的副唤醒词为准。
 
 @param word 副唤醒词（必须）
 @param pinyin 副唤醒词的拼音
 @param threshold 副唤醒词的阈值
 @param greetings 副唤醒词的欢迎语
 */
-(void) updateMinorWakeupWord:(NSString*) word pinyin:(NSString*) pinyin threshold:(NSString*)threshold greetings:(NSMutableArray*)greetings;

/*!
 获取当前的副唤醒词
 
 @return NSString 副唤醒词, 若无则返回nil
 */
-(NSString*)getMinorWakeupWord;

/*!
 更新命令唤醒词的接口，这类唤醒词会在唤醒之后执行一条指令，不能打断正在播报的语音,支持设置多个命令唤醒词，所以参数为数组，重复调用会以最新的命令唤醒词数组为准
 
 @param actions 命令唤醒词对应的command命令（必须）
 @param words 命令唤醒词的汉字（必须）
 @param pinyin 命令唤醒词的拼音（必须）
 @param threshold 命令唤醒词的阈值（必须）
 @param greetings  命令唤醒词对应的唤醒语，一个唤醒词可以设置多条欢迎语，所以参数为二维数组，如果想要某个唤醒词不要欢迎语，那么该第二维数组的string可以设置为空字符串""
 */
-(void) updateCommandWakeupWord:(NSMutableArray<NSString*>*)actions words:(NSMutableArray<NSString*>*)words pinyin:(NSMutableArray<NSString*>*)pinyin threshold:(NSMutableArray<NSString*>*)threshold greetings:(NSMutableArray<NSMutableArray<NSString*>*>*) greetings;

/*!
 清空命令唤醒词
 */
-(void)clearCommandWakeupWord;

/*!
 添加命令唤醒词，且不会覆盖之前的命令唤醒词
 
 @param actions 命令唤醒词对应的command命令（必须)
 @param words 命令唤醒词的汉字（必须）
 @param pinyin 命令唤醒词的拼音（必须）
 @param threshold  命令唤醒词的阈值（必须)
 @param greetings 命令唤醒词对应的唤醒语，一个唤醒词可以设置多条欢迎语，所以参数为二维数组，如果想要某个唤醒词不要欢迎语，那么该第二维数组的string可以设置为空字符串""
 */
-(void) addCommandWakeupWord:(NSMutableArray<NSString*>*)actions words:(NSMutableArray<NSString*>*)words pinyin:(NSMutableArray<NSString*>*)pinyin threshold:(NSMutableArray<NSString*>*)threshold greetings:(NSMutableArray<NSMutableArray<NSString*>*>*)greetings;

/*!
 移除指定的命令唤醒词
 
 @param words 命令唤醒词的汉字（必须）
 */
-(void)removeCommandWakeupWord:(NSMutableArray<NSString*>*)words;

/*!
 更新打断唤醒词的接口,这类唤醒词能打断正在播报的语音并且将唤醒词送入识别
 
 支持设置多个打断唤醒词，所以参数为数组，重复调用会以最新的打断唤醒词数组为准。
 
 @param words 打断唤醒词, 为NSString数组, 必须
 @param pinyin 打断唤醒词的拼音, 形如：ni hao xiao chi, 为NSString数组, 必须
 @param threshold 打断唤醒词的阈值, 形如：0.120(取值范围：0-1) 为NString数组, 必须
 */
-(void)updateShortcutWakeupWord:(NSMutableArray<NSString*>*)words pinyin:(NSMutableArray<NSString*>*)pinyin threshold:(NSMutableArray<NSString*>*)threshold;

/*!
 清空打断唤醒词
 */
-(void) clearShortCutWakeupWord;

/*!
 添加新的打断唤醒词，且不会覆盖之前的唤醒词
 
 @param words 打断唤醒词的汉字（必须）
 @param pinyin 打断唤醒词的拼音（必须）
 @param threshold 打断唤醒词的阈值（必须）
 */
-(void)addShortcutWakeupWord:(NSMutableArray<NSString*>*)words pinyin:(NSMutableArray<NSString*>*)pinyin threshold:(NSMutableArray<NSString*>*)threshold;

/*!
 移除指定的打断唤醒词
 
 @param words 打断唤醒词的汉字（必须）
 */
-(void)removeShortcutWakeupWord:(NSMutableArray<NSString*>*)words;

/*!
 添加主唤醒词的接口,支持添加多个主唤醒词，调用此接口会覆盖控制台配置的主唤醒词，直到通过removeMainWakeupWord接口移除。
 （相同words重复添加无效，如需要改变其他属性，需先移除再重新添加）
 
 @param words 主唤醒词，不为nil
 @param pinyin 主唤醒词的拼音，不为nil
 @param threshold 主唤醒词的阈值，不为nil
 @param greetings 主唤醒词的欢迎语，不为nil；如果某个唤醒词不想要欢迎语，在对应的维度设为NULL
 */
-(void) addMainWakeupWord:(NSMutableArray<NSString*>*)words pinyin:(NSMutableArray<NSString*>*)pinyin threshold:(NSMutableArray<NSString*>*)threshold greetings:(NSMutableArray<NSMutableArray<NSString*>*>*)greetings;

/*!
 移除指定的主唤醒词,如果移除了所有通过addMainWakeupWord接口添加的主唤醒词，则主唤醒词重置为控制台所配置的
 
 @param words 主唤醒词的汉字（必须）
 */
-(void) removeMainWakeupWord:(NSMutableArray<NSString*>*)words;


@end
