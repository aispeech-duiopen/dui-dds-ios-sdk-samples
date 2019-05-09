
/*!
 
 @header DDSManasgerProtocol.h
 
 @brief This is the protocol file .
 
 @author aispeech
 
 @copyright  2018 aispeech. All rights reserved.
 
 @version   1.0.2.1
 
 */

#import <Foundation/Foundation.h>

/*!
 DDSManagerProtocol协议说明
 */
@protocol DDSManagerDelegate <NSObject>
@optional

/*!
 SDK初始化回调方法
 
 @param isFull
 false -- 只有本地模块初始化成功，开发者还需要通过update去更新资源包.
 true  -- SDK初始化完全成功.
 */
-(void)onInitComplete:(BOOL)isFull;

/*!
 更新失败的回调
 @param what errorid
 @param error error描述
 */
-(void)onError:(int)what Error:(NSString*)error;

/*!
 授权成功回调方法
 */
-(void)onAuthSuccess;


/*!
 授权失败回调方法
 
 @param what the errId.
 @param error the error message.
 */
-(void)onAuthFailed:(NSString*)what Error:(NSString*)error;

/*!
 发现资源有更新的回调方法
 @param detail 更新日志
 */
-(void)onUpdateFound:(NSString *)detail;

/*!
 资源更新成功的回调方法
 */
-(void)onUpdateFinish;

/*!
 资源更新过程中进度通知的回调
 @param progress 下载进度 取值范围0-100
 */
-(void)onDownloadProgress:(float) progress;

/*!
 需要更新本地sdk，本地sdk与dui平台选择的dui内核版本号不匹配
 @param version 当前没有用到，取值为“”字符串
 */
-(void)onUpgrade:(NSString *) version;



/*!
 第三方合成开始的回调
 
 @param type 合成的类型 text/ssml
 @param content 要合成的内容
 */
-(void)onStart:(NSString*)type data:(NSString*)content;


/*!
 第三方合成结束的回调
 */
-(void)onStop;
@end

