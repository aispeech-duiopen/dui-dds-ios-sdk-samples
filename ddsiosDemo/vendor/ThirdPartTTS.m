//
//  xfTTS.m
//  ddsiosDemo
//
//  Created by aispeech009 on 26/03/2018.
//  Copyright © 2018 speech. All rights reserved.
//

#import "ThirdPartTTS.h"
#import "DDSManager.h"

static NSString * TAG = @"externalTTS";

@implementation ThirdPartTTS

-(id)init{
    NSLog(@"初始化第三发语音TTS");
    return self;
}

-(void)startTTS:(NSString*)text{
    //启动合成会话
    NSLog(@"开始播放第三方TTS");
}

- (void)stopTTS{
    NSLog(@"停止播放第三方TTS");
}



/**
 pause player
 Notice：
 Only apply to normal TTS
 **/
- (void)pauseSynBtnHandler{
    NSLog(@"暂停播放第三方TTS");
}


/**
 resume palyer
 Notice：
 Only apply to normal TTS
 **/
- (void)resumeSynBtnHandler{
    NSLog(@"恢复播放第三方TTS");
}

//合成播放进度  第三方tts回调
- (void) progress:(int) progress{
    if (progress==100) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSelector:@selector(delayNotifyTTSEnd) withObject:nil afterDelay:1];//这里播报结束还没有结束，所以延迟执行我们的SDK函数
        });
    }
}

-(void)delayNotifyTTSEnd{
    [[DDSManager shareInstance] notifyTTSEnd];
}

@end
