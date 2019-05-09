//
//  AuthorizationManager.m
//  AddressBook_07
//
//  Created by mac on 16/3/11.
//  Copyright © 2016年 hngydx. All rights reserved.
//

#import "AuthorizationManager.h"
#import <ContactsUI/ContactsUI.h>
#import <AddressBook/AddressBookDefines.h>
#import <AddressBook/ABRecord.h>
#import "AddressBook/AddressBook.h"

#import "DDSManager.h"
#import <AVFoundation/AVFoundation.h>

static NSString * TAG = @"AIContacts";

@interface AuthorizationManager ()<CNContactPickerDelegate,UIWebViewDelegate>

@end

@implementation AuthorizationManager


- (void)requestAuthorizationForAddressBook {
    
    if ([[UIDevice currentDevice].systemVersion floatValue]>=9.0){
        
        CNAuthorizationStatus authorizationStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        if (authorizationStatus == CNAuthorizationStatusNotDetermined) {
            CNContactStore *contactStore = [[CNContactStore alloc] init];
            [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if (granted) {
                    
                } else {
                    NSLog(@"授权失败, error=%@", error);
                }
            }];
        }
        
    }else
    {
        NSLog(@"请升级系统");
    }
    
    
}

- (void)getmyAddressbook {
    CNAuthorizationStatus authorizationStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (authorizationStatus == CNAuthorizationStatusAuthorized) {
        NSLog(@"没有授权...");
    }
    
    self.myDict = [[NSMutableDictionary alloc]init];
    
    // 获取指定的字段,并不是要获取所有字段，需要指定具体的字段
    NSArray *keysToFetch = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey];
    CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    
    [contactStore enumerateContactsWithFetchRequest:fetchRequest error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        NSLog(@"-------------------------------------------------------");
        
        NSString *givenName = contact.givenName;
        NSString *familyName = contact.familyName;
        NSLog(@"%@, givenName=%@, familyName=%@", TAG, givenName, familyName);
        
        NSString *nameStr = [NSString stringWithFormat:@"%@%@",contact.familyName,contact.givenName];
        
        NSArray *phoneNumbers = contact.phoneNumbers;
        
        for (CNLabeledValue *labelValue in phoneNumbers) {
            NSString *label = labelValue.label;
            CNPhoneNumber * phoneNumber = labelValue.value;
            
            NSLog(@"%@, label=%@, phone=%@", TAG, label, phoneNumber.stringValue);
            [_myDict setObject:phoneNumber.stringValue forKey:nameStr];
        }
        
    }];
    
    
    //NSLog(@"mydict is ==== %@",_myDict);
    NSArray * arrayName = [_myDict allKeys];
    for (int i=0; i<[arrayName count]; i++) {
        NSLog(@"%@, name: %@ phoneNumber:%@", TAG, arrayName[i], [_myDict objectForKey:arrayName[i]]);
    }
}

-(void)callPhone:(NSString *)phoneNumber object:(AITestDUICtrl*)object{
    UIWebView * callWebView = [[UIWebView alloc] init];
    NSURL *telURL          = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNumber]];
    [callWebView loadRequest:[NSURLRequest requestWithURL:telURL]];
    [object.view addSubview:callWebView];
}

-(void)detectCall
{
    __weak AuthorizationManager * managerContacts = self;
    self.callCenter = [[CTCallCenter alloc] init];
    self.callCenter.callEventHandler = ^(CTCall* call) {
        if ([call.callState isEqualToString:CTCallStateDisconnected])
        {
            NSLog(@"%@, 挂断了电话咯Call has been disconnected", TAG);
            dispatch_async(dispatch_get_main_queue(), ^{
                [managerContacts beforeRecord];
                [[DDSManager shareInstance] enableWakeup];
            });
        }
        else if ([call.callState isEqualToString:CTCallStateConnected])
        {
            NSLog(@"%@, 电话通了Call has just been connected", TAG);
        }
        else if([call.callState isEqualToString:CTCallStateIncoming])
        {
            NSLog(@"%@, 来电话了Call is incoming", TAG);
            
        }
        else if ([call.callState isEqualToString:CTCallStateDialing])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[DDSManager shareInstance] disableWakeup];
                [[DDSManager shareInstance] stopDialog];
            });
            NSLog(@"%@, 正在拨出电话call is dialing", TAG);
        }
        else
        {
            NSLog(@"%@, 什么也没做Nothing is done", TAG);
            dispatch_async(dispatch_get_main_queue(), ^{
                [managerContacts beforeRecord];
                [[DDSManager shareInstance] enableWakeup];
            });
        }
    };
}

-(void)beforeRecord{
    AVAudioSession * session = [AVAudioSession sharedInstance];
    if (!session) printf("ERROR INITIALIZING AUDIO SESSION! \n");
    else{
        
        NSError *nsError = nil;
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
        
        if (nsError) printf("couldn't set audio category!");
        [session setActive:YES error:&nsError];
        if (nsError) printf("AudioSession setActive = YES failed");
    }
}

@end
