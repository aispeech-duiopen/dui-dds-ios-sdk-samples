//
//  AIUpdateContextIntent.h
//  ddsios
//
//  Created by aispeech009 on 2018/12/4.
//  Copyright © 2018 speech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AIUpdateContextIntent : NSObject

@property(nonatomic, strong) NSString * contextIntentKey;

@property(nonatomic, strong) NSObject * contextIntentValue;

@property(nonatomic, strong) NSString * contextIntentSkillId;

- (NSString*) toString;

@end

NS_ASSUME_NONNULL_END
