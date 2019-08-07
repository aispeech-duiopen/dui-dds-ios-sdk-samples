//
//  DDSAuthInfo.h
//  ddsios
//
//  Created by hc on 2019/6/2.
//  Copyright © 2019 speech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDSAuthInfo : NSObject

@property (nonatomic, strong) NSString * clientId;//发邮件找思必驰项目经理申请
@property (nonatomic, strong) NSString * userId;//aispeechUserId
@property (nonatomic, strong) NSString * authCode;//授权码，从账号对接SDK中获取
@property (nonatomic, strong) NSString * codeVerifier;//在 authorize 中获取 authcode 的匹配的值
@property (nonatomic, strong) NSString * redirectUri;// 针对特殊需求的项目对接，一般使用默认值


/*!
 创建DDSAuthInfo实例
 */
+(DDSAuthInfo *) shareInstance;

/*!
 销毁DDSAuthInfo实例
 */
+(void)deallocInstance;

/*!
 获取DDSAuthInfo实例
 
 @return DDSAuthInfo
 */

+(DDSAuthInfo *) getInstance;


@end

NS_ASSUME_NONNULL_END
