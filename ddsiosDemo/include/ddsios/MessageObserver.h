//
//  MessageObserver.h
//  ddsios
//
//  Created by hc on 2017/9/22.
//  Copyright © 2017年 speech. All rights reserved.
//

/*!
 
 @header MessageObserver.h
 
 @brief This is the interface file .
 
 @author aispeech
 
 @copyright  2017 aispeech. All rights reserved.
 
 @version   1.0.1.2
 
 */

#import <Foundation/Foundation.h>
#import "DDSManager.h"

/*!
 messageObserver 说明
*/
@interface MessageObserver : NSObject<AIMessageDelegate>

/*!
 messageObserver委托
*/
@property(nonatomic,weak) id<AIMessageDelegate> delegate;

@end
