//
//  WakeupEngineManagerProtocol.h
//  ddsios
//
//  Created by aispeech009 on 2018/11/1.
//  Copyright © 2018 speech. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 WakeupEngineManagerProtocol协议说明
 */
@protocol WakeupEngineManagerProtocol <NSObject>

@optional

/**
 配置欢迎语

 @param wakeupResult 唤醒结果
 @return 返回json串,示例：{"greeting":"欢迎语"}
 */
-(NSString*)onWakeup:(NSString*)wakeupResult;

@end
