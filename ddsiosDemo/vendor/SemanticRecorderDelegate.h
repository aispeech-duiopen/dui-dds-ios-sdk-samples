//
//  SemanticRecorderDelegate.h
//  jnlu-semantic-test
//
//  Created by gaozhiqun on 2018/2/6.
//  Copyright © 2018年 gaozhiqun. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SemanticRecorderDelegate <NSObject>

-(void) processingData: (NSData*) data segmentNum: (int) segmentNum sessionId: (NSString *) sessionId;

@end
