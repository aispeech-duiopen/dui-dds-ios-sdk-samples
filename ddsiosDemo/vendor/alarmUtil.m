//
//  alarmUtil.m
//  ddsiosDemo
//
//  Created by aispeech009 on 28/03/2018.
//  Copyright © 2018 speech. All rights reserved.
//

#import "alarmUtil.h"
#include <stdio.h>
#include <time.h>
#include "fdatefunc.h"

static NSString * TAG = @"alarmUtil";

@implementation alarmUtil

//NSDate转NSString
+ (NSString *)stringFromDate:(NSDate *)date
{
    //获取系统当前时间
    //NSDate *currentDate = [NSDate date];
    //用于格式化NSDate对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //NSDate转NSString
    NSString *currentDateString = [dateFormatter stringFromDate:date];
    //输出currentDateString
    NSLog(@"%@, alarm %@ ---> %@", TAG, date, currentDateString);
    return currentDateString;
}

//NSString转NSDate
+ (NSDate *)dateFromString:(NSString *)string
{
    //需要转换的字符串
    //NSString *dateString = @"2015-06-26 08:08:08";
    //设置转换格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //NSString转NSDate
    NSDate *date=[formatter dateFromString:string];
    NSLog(@"%@, alarm %@ ---> %@", TAG, string, date);
    return date;
}

+(NSString *)getLunarHoliDayDate:(NSDate *)date
{
    NSTimeInterval timeInterval_day = (float)(60*60*24);
    NSDate *nextDay_date = [NSDate dateWithTimeInterval:timeInterval_day sinceDate:date];
    //NSCalendar *localeCalendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSChineseCalendar] autorelease];
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSChineseCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:nextDay_date];
    if ( 1 == localeComp.month && 1 == localeComp.day ) {
        //[localeCalendar release];
        return @"除夕";
    }
    NSDictionary *chineseHoliDay = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"春节", @"1-1",
                                    @"元宵节", @"1-15",
                                    @"端午节", @"5-5",
                                    @"七夕", @"7-7",
                                    @"中元节", @"7-15",
                                    @"中秋节", @"8-15",
                                    @"重阳节", @"9-9",
                                    @"腊八", @"12-8",
                                    nil];
    localeComp = [localeCalendar components:unitFlags fromDate:date];
    NSString *key_str = [NSString stringWithFormat:@"%ld-%ld",(long)localeComp.month,(long)localeComp.day];
    return [chineseHoliDay objectForKey:key_str];
}

+ (NSString*)festivalToDateString:(NSString *)festival{
    NSDictionary *chineseHoliDay = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"1-1", @"春节",
                                    @"1-15", @"元宵节",
                                    @"5-5", @"端午节",
                                    @"7-7", @"七夕",
                                    @"7-15", @"中元节",
                                    @"8-15", @"中秋节",
                                    @"9-9", @"重阳节",
                                    @"12-8", @"腊八",
                                    nil];
    if ([[chineseHoliDay allKeys] containsObject:festival]) {
        return [chineseHoliDay objectForKey:festival];
    }else{
        return nil;
    }
}

+ (NSString*)lunToSun:(NSString*)year month:(NSString*)month day:(NSString*)day{
    LunarDate LD={
        .year=(U16)atoi([year UTF8String]),
        .month=(U8)atoi([month UTF8String]) - 1,
        .day=(U8)atoi([day UTF8String])
    };
    SunDate sunDate;
    BL* bl=getLunarBLArray(LD.year);
    int ret;
    U8 tmp=lunarLeapMonth(LD.year);
    ret = lunarToSun(&LD,&sunDate,bl,tmp);
    if(ret){
        fprintf(stderr,"转换失败\n");
        return nil;
    }
    printf("对应的日期是%u-%u-%u\n",sunDate.year,sunDate.month,sunDate.day);
    freeBLArray(bl);
    return [NSString stringWithFormat:@"%u-%u-%u",sunDate.year,sunDate.month,sunDate.day];
}

@end
