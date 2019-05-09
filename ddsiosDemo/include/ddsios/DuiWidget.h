//
//  DuiWidget.h
//  ddsios
//
//  Created by hc on 2017/9/30.
//  Copyright © 2017年 speech. All rights reserved.
//

#import <Foundation/Foundation.h>

static const NSString *TYPE_TEXT = @"text";
static const NSString *TYPE_CONTENT = @"content";
static const NSString *TYPE_LIST = @"list";
static const NSString *TYPE_MEDIA = @"media";
static const NSString *TYPE_WEB = @"web";

static const NSString *WIDGET_TYPE = @"duiWidget";
static const NSString *WIDGET_COUNT = @"count";
static const NSString *WIDGET_CONTENT = @"content";

static const NSString *WIDGET_TEXT = @"text";
static const NSString *WIDGET_TITLE = @"title";
static const NSString *WIDGET_SUBTITLE = @"subTitle";
static const NSString *WIDGET_LABEL = @"label";
static const NSString *WIDGET_IMAGEURL = @"imageUrl";
static const NSString *WIDGET_LINKURL = @"linkUrl";
static const NSString *WIDGET_URL = @"url";
static const NSString *WIDGET_EXTRA = @"extra";

@interface DuiWidget : NSObject

- (id)initWithType:(NSString *)type;

- (DuiWidget *)setType:(const NSString *)type;

- (DuiWidget *)addContent:(const NSString *)contentName ContentValue:(NSString *)contentValue;

- (DuiWidget *)addWidget:(DuiWidget *)widget;

- (DuiWidget *)addExtra:(NSString *)key Value:(NSString *)value;

- (NSString *)toString;

@end
