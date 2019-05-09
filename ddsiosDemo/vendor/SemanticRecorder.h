//
//  SemanticRecorder.h
//  JDSemanticBotTests
//
//  Created by gaozhiqun on 2018/2/2.
//  Copyright © 2018年 gaozhiqun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "SemanticRecorderDelegate.h"

//@class SemanticRecorder;

@interface SemanticRecorder : NSObject

@property (nonatomic, weak) id<SemanticRecorderDelegate> semanticRecorderDelegate;

@property (nonatomic,assign) int segmentNum;

@property (strong, nonatomic) NSString * sessionId;


-(BOOL)isRecording;

- (void)startRecording;

-(void)stopRecording;

@end
