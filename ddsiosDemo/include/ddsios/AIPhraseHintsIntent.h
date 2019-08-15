//
//  AIPhraseHintsIntent.h
//  ddsios
//
//  Created by 夏念鑫 on 2019/8/15.
//  Copyright © 2019 speech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AIPhraseHintsIntent : NSObject

@property (nonatomic,copy) NSString *type;

@property (nonatomic,copy) NSString *name;

@property (nonatomic,strong) NSMutableArray<NSString *> * data;

- (NSString*) toString;
@end

NS_ASSUME_NONNULL_END
