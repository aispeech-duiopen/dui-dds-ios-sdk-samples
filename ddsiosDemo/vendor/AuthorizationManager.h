//
//  AuthorizationManager.h
//  AddressBook_07
//
//  Created by mac on 16/3/11.
//  Copyright © 2016年 hngydx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AITestDUICtrl.h"
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>

@interface AuthorizationManager : NSObject

@property(nonatomic,strong) NSMutableDictionary *myDict;
@property (nonatomic, strong) CTCallCenter *callCenter;

-(void)getmyAddressbook;
-(void)callPhone:(NSString *)phoneNumber object:(AITestDUICtrl*)object;
-(void)detectCall;

@end
