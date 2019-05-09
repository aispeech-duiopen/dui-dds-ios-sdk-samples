//
//  SemanticRecorder.m
//  JDSemanticBotTests
//
//  Created by gaozhiqun on 2018/2/2.
//  Copyright © 2018年 gaozhiqun. All rights reserved.
//  This class is designed to call system recorder and send data to semantic recognizer

#import "SemanticRecorder.h"
#import <AudioToolbox/AudioToolbox.h>
#import <CoreMedia/CMSync.h>

#define QUEUE_BUFFER_SIZE 3      // 定义了三个缓冲区
#define kDefaultBufferDurationSeconds 0.03//调整这个值使得录音的缓冲区大小为960,实际会小于或等于960,需要处理小于960的情况
#define kDefaultSampleRate 16000   //定义采样率为8000

static BOOL isRecording = NO;

@implementation SemanticRecorder{
    UInt64                          startTime;
    Float64                         hostTime;
    
    AudioQueueRef _audioQueue;                          //输出音频播放队列
    AudioStreamBasicDescription _recordFormat;
    AudioQueueBufferRef _audioBuffers[QUEUE_BUFFER_SIZE]; //输出音频缓存
}
//@property (nonatomic, assign) BOOL isRecording;

-(id) init{
   self = [super init];
    if (self) {
        //重置下
        memset(&_recordFormat, 0, sizeof(_recordFormat));
        _recordFormat.mSampleRate = kDefaultSampleRate;
        _recordFormat.mChannelsPerFrame = 1;
        _recordFormat.mFormatID = kAudioFormatLinearPCM;
        
        _recordFormat.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
        _recordFormat.mBitsPerChannel = 16;
        _recordFormat.mBytesPerPacket = _recordFormat.mBytesPerFrame = (_recordFormat.mBitsPerChannel / 8) * _recordFormat.mChannelsPerFrame;
        _recordFormat.mFramesPerPacket = 1;
        
        [self resetRecorder];
    }
    return self;
}

void inputBufferHandler(void *inUserData, AudioQueueRef inAQ, AudioQueueBufferRef inBuffer, const AudioTimeStamp *inStartTime,UInt32 inNumPackets, const AudioStreamPacketDescription *inPacketDesc)
{
    if (inNumPackets > 0) {
        SemanticRecorder *recorder = (__bridge SemanticRecorder*)inUserData;
        [recorder processAudioBuffer:inBuffer withQueue:inAQ];
    }
    
    if (isRecording) {
        AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, NULL);
    }
}

- (void)processAudioBuffer:(AudioQueueBufferRef )audioQueueBufferRef withQueue:(AudioQueueRef )audioQueueRef
{
    NSMutableData * dataM = [NSMutableData dataWithBytes:audioQueueBufferRef->mAudioData length:audioQueueBufferRef->mAudioDataByteSize];
    
    if (dataM.length < 960) { //处理长度小于960的情况,此处是补00
        Byte byte[] = {0x00};
        NSData * zeroData = [[NSData alloc] initWithBytes:byte length:1];
        for (NSUInteger i = dataM.length; i < 960; i++) {
            [dataM appendData:zeroData];
        }
    }
    
    //Sending message tp JnluSemanticRecognizer
    //NSLog(@"Data recorded: %@", dataM);
    NSLog(@"Voice recored length: %lu",(unsigned long)dataM.length);
    
    if(dataM.length>0){
    [_semanticRecorderDelegate processingData:[dataM copy] segmentNum:_segmentNum sessionId: _sessionId];
    _segmentNum++;
    }
}

-(void)resetRecorder{
    //初始化音频输入队列
    AudioQueueNewInput(&_recordFormat, inputBufferHandler, (__bridge void *)(self), NULL, NULL, 0, &_audioQueue);
    
    //计算估算的缓存区大小
    int frames = (int)ceil(kDefaultBufferDurationSeconds * _recordFormat.mSampleRate);
    int bufferByteSize = frames * _recordFormat.mBytesPerFrame;
    
    NSLog(@"缓存区大小%d",bufferByteSize);
    
    //创建缓冲器
    for (int i = 0; i < QUEUE_BUFFER_SIZE; i++){
        AudioQueueAllocateBuffer(_audioQueue, bufferByteSize, &_audioBuffers[i]);
        AudioQueueEnqueueBuffer(_audioQueue, _audioBuffers[i], 0, NULL);
    }
}


-(void) startRecording
{
    // 开始录音
    NSLog(@"Start Recording!");
    [self resetRecorder];
    AudioQueueStart(_audioQueue, NULL);
    isRecording = YES;
    _segmentNum = 0;
    _sessionId = [self uuid];
}

-(NSString *)uuid{
    // create a new UUID which you own
    CFUUIDRef uuidref = CFUUIDCreate(kCFAllocatorDefault);
    // create a new CFStringRef (toll-free bridged to NSString)
    // that you own
    CFStringRef uuid = CFUUIDCreateString(kCFAllocatorDefault, uuidref);
    NSString *result = (__bridge NSString *)uuid;
    //release the uuidref
    CFRelease(uuidref);
    // release the UUID
    CFRelease(uuid);
    return result;
}

-(void) stopRecording
{
    NSLog(@"%s,stop recording",__func__);
    
    if (isRecording)
    {
        isRecording = NO;
        //停止录音队列和移除缓冲区,以及关闭session
        dispatch_async(dispatch_get_main_queue(), ^{
           AudioQueueStop(_audioQueue, true);
            NSLog(@"AudioQueue Stopped!");
            //移除缓冲区,true代表立即结束录制，false代表将缓冲区处理完再结束
            AudioQueueDispose(_audioQueue, true);
            NSLog(@"AudioQueue Buffer removed!");
        });
    }
    NSLog(@"Recorder successfully Stop Recording!");
}

-(BOOL) isRecording{
    return isRecording;
}


@end
