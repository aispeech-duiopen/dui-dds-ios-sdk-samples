//
//  DDSConfig.h
//  aios
//
//  Created by speech_dui on 2017/8/23.
//  Copyright © 2017年 yuruilong. All rights reserved.
//

#ifndef DDSConfig_h
#define DDSConfig_h

//基本配置项
static NSString * K_PRODUCT_ID = @"PRODUCT_ID";
static NSString * K_PRODUCT_VERSION = @"PRODUCT_VERSION";
static NSString * K_USER_ID = @"USER_ID";
static NSString * K_ALIAS_KEY = @"ALIAS_KEY";
static NSString * K_DUICORE_ZIP = @"DUICORE_ZIP";
static NSString * K_CUSTOM_ZIP = @"CUSTOM_ZIP";
static NSString * K_DEVICE_ID = @"DEVICE_ID";
static NSString * K_AISPEECH_USER_ID = @"AISPEECH_USER_ID";


//授权配置项
static NSString * K_AUTH_TYPE = @"AUTH_TYPE";
static NSString * K_API_KEY = @"API_KEY";
static NSString * K_ACCESS_TOKEN = @"ACCESS_TOKEN";
static NSString * K_PRODUCT_KEY = @"PRODUCT_KEY";
static NSString * K_PRODUCT_SECRET = @"PRODUCT_SECRET";

//TTS配置项
static NSString * K_TTS_MODE = @"TTS_MODE";
static NSString * K_CUSTOM_TIPS = @"CUSTOM_TIPS";
static NSString * K_TTS_CACHE = @"TTS_CACHE";
static NSString * K_CACHE_COUNT = @"CACHE_COUNT";
static NSString * K_CUSTOM_AUDIO = @"CUSTOM_AUDIO";
static NSString * K_CUSTOM_AUDIO_MODE = @"CUSTOM_AUDIO_MODE";

//录音配置项
static NSString * K_RECORDER_MODE = @"RECORDER_MODE";
static NSString * K_AEC_MODE = @"AEC_MODE";
static NSString * K_RECORDER_PCM = @"local_recorder.pcm";

//识别配置项
static NSString * K_ASR_ROUTER = @"ASR_ROUTER";
static NSString * K_ASR_TIPS = @"ASR_TIPS";
static NSString * K_AUDIO_COMPRESS = @"AUDIO_COMPRESS";
static NSString * K_ASR_ENABLE_PUNCTUATION = @"ENABLE_PUNCTUATION";
static NSString * K_VAD_TIMEOUT = @"VAD_TIMEOUT";
static NSString * K_ASR_ENABLE_TONE = @"ASR_ENABLE_TONE";
static NSString * K_CLOSE_TIPS = @"CLOSE_TIPS";

//唤醒配置项
static NSString * K_WAKEUP_ROUTER = @"WAKEUP_ROUTER";
static NSString * K_ONESHOT_MIDTIME = @"ONESHOT_MIDTIME";
static NSString * K_ONESHOT_ENDTIME = @"ONESHOT_ENDTIME";
static NSString * K_WAKEUP_REDIALOG = @"WAKEUP_REDIALOG";

//调试配置项
static NSString * K_LOG_LEVEL = @"LOG_LEVEL";
static NSString * K_CACHE_PATH = @"CACHE_PATH";
static NSString * K_WAKEUP_DEBUG = @"WAKEUP_DEBUG";
static NSString * K_VAD_DEBUG = @"VAD_DEBUG";
static NSString * K_ASR_DEBUG = @"ASR_DEBUG";
static NSString * K_TTS_DEBUG = @"TTS_DEBUG";

//性别识别开关
static NSString * K_USE_GENDER = @"USE_GENDER";

#endif /* DDSConfig_h */
