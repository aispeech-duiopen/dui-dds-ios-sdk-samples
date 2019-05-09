//
//  xfTTS.h
//  ddsiosDemo
//
//  Created by aispeech009 on 26/03/2018.
//  Copyright © 2018 speech. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ThirdPartTTS : NSObject

- (void)startTTS:(NSString*)text;
- (void)stopTTS;
- (void)pauseSynBtnHandler;
- (void)resumeSynBtnHandler;

@end
