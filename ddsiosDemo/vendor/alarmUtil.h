//
//  alarmUtil.h
//  ddsiosDemo
//
//  Created by aispeech009 on 28/03/2018.
//  Copyright © 2018 speech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface alarmUtil : NSObject

+ (NSString *)stringFromDate:(NSDate *)date;
+ (NSDate *)dateFromString:(NSString *)string;
+ (NSString *)getLunarHoliDayDate:(NSDate *)date;
+ (NSString*)festivalToDateString:(NSString *)festival;
+ (NSString*)lunToSun:(NSString*)year month:(NSString*)month day:(NSString *)day;

@end
