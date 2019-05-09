//
//  AppDelegate.m
//  aios
//
//  Created by hudson on 2017/6/19.
//  Copyright © 2017年 yuruilong. All rights reserved.
//

#import "AppDelegate.h"
#import "AITestDUICtrl.h"

//#import <Bugly/Bugly.h>
#import <AudioToolbox/AudioToolbox.h>


static NSString * TAG = @"AppDelegate";

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //[self redirectNSlogToDocumentFolder];
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AITestDUICtrl *test = [story instantiateViewControllerWithIdentifier:@"AITestDUICtrl"];
    UINavigationController *navc =  [[UINavigationController alloc] initWithRootViewController:test];
    navc.navigationBar.barStyle = UIBarStyleBlack;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //请求发送本地通知
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    self.window.rootViewController = navc;
        
    [Bugly startWithAppId:@"9810c88a8c"];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
    //闹钟通知，将要进入前台的都是取消小红点
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//接受后台通知
- (void)application:(UIApplication *)application didReceiveLocalNotification:(nonnull UILocalNotification *)notification{
    UIApplicationState state = application.applicationState;
    if(state == UIApplicationStateActive){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:notification.alertBody delegate:self cancelButtonTitle:notification.alertAction otherButtonTitles:nil, nil];
        [alert show];
        //设置铃声和震动
        dispatch_async(dispatch_get_main_queue(), ^{
            [self addVibrate];
            //[self removeVibrate];
        });
        application.applicationIconBadgeNumber = 0;
    }else{
        
    }
}

- (void)redirectNSlogToDocumentFolder
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"bootloader.log"];
    NSString *logFilePath = [documentDirectory stringByAppendingPathComponent:fileName];

    if (logFilePath.length) {
        // 先删除已经存在的文件
        NSFileManager *defaultManager = [NSFileManager defaultManager];
        [defaultManager removeItemAtPath:logFilePath error:nil];
        // 将log输入到文件
        freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
        freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
    }
}

-(void)addVibrate {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    AudioServicesPlaySystemSound(1008);
}

-(void)removeVibrate {
    [self performSelector:@selector(stopVibrate) withObject:nil afterDelay:3]; //设置1秒延时，
}

void vibrateCallback(SystemSoundID sound,void * clientData) {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate); //震动
    AudioServicesPlaySystemSound(1008);
    //[[SettingManager shared] removeSoundID_Vibrate];
}
-(void)stopVibrate {
    AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate);
    AudioServicesRemoveSystemSoundCompletion(1008);
}



@end


