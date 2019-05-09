//
//  setSwitchViewController.m
//  ddsiosDemo
//
//  Created by aispeech009 on 25/10/2017.
//  Copyright © 2017 speech. All rights reserved.
//

#import "setSwitchViewController.h"
#import "LLSwitch.h"
#import "DDSManager.h"
#import "SVProgressHUD.h"
#import "AITestTriggerIntent.h"
#import "AITestUpdateVocab.h"
#import "updateWakeupWords.h"
#import "CommandObserver.h"
#import "MessageObserver.h"

static int switch1 = 0;
static int switch2 = 0;
static int switch3 = 0;
static int switch4 = 0;

extern BOOL isA;


@interface setSwitchViewController ()<LLSwitchDelegate>

@property (strong, nonatomic) CommandObserver * commandObserver;
@property (strong, nonatomic) MessageObserver * messageObserver;

@property UILabel* lable1;
@property UILabel* lable2;
@property UILabel* lable3;
@property UILabel* lable4;
@property UILabel* lable5;

@property UILabel* lableTips1;
@property UILabel* lableTips2;
@property UILabel* lableTips3;
@property UILabel* lableTips4;

@property UIView* view1;
@property UIView* view2;
@property UIView* view3;
@property UIView* view4;

@property UIButton* btnTriggerIntent;
@property UIButton* btnupdateVocab;
@property UIButton* btnUpdate;
@property UIButton* btnUpdateWakeup;

@end

@implementation setSwitchViewController

#pragma mark --按键
- (void)slienceMode{
    DDSManager *manager = [DDSManager shareInstance];
    [manager setDDSMode:YES];
    NSLog(@"YCXMenu slienceMode");
}
- (void)normalMode{
    DDSManager *manager = [DDSManager shareInstance];
    [manager setDDSMode:NO];
    NSLog(@"YCXMenu normalMode");
}

- (void)startWakeup{
    NSMutableArray * arr = [[DDSManager shareInstance] getWakeupWords];
    if([arr count]){
        NSString *strData;
        if([arr count] == 1){
            strData = [[NSString alloc] initWithString:[arr componentsJoinedByString:@""]];
        }else{
            strData = [[NSString alloc] initWithString:[arr componentsJoinedByString:@"或"]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showSuccessWithStatus:@"唤醒已经开启"];
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [SVProgressHUD dismiss];
        });
    }
    [[DDSManager shareInstance] enableWakeup];
    NSLog(@"YCXMenu startWakeup");
}

- (void)stopWakeup{
    [[DDSManager shareInstance] disableWakeup];
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showSuccessWithStatus:@"唤醒已经关闭"];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [SVProgressHUD dismiss];
    });
    NSLog(@"YCXMenu stopWake");
}

- (void)stopDialog{
    ///停止对话
    NSLog(@"--------1停止对话");
    [[DDSManager shareInstance] stopDialog];
}

- (void)startDialog {
    ///停止对话
    NSLog(@"--------1停止对话");
    [[DDSManager shareInstance] startDialog];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)startVad{
    isA = YES;
    NSLog(@"YCXMenu startVad");
}

- (void)stopVad{
    isA = NO;
    NSLog(@"YCXMenu stopVad");
}

- (void)versionUpdate{
    //[[DDSManager shareInstance] disableWakeup];
    _btnUpdate.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
    DDSManager *manager = [DDSManager shareInstance];
    [manager update];
}
-(void)versionUpdatePress{
    
    _btnUpdate.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    //[_btnUpdate setTitle:@"松开 结束" forState:UIControlStateNormal];
}

- (void)triggerIntent{
    
    _btnTriggerIntent.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
    AITestTriggerIntent *triggerIntent = [self.storyboard instantiateViewControllerWithIdentifier:@"TestTriggerIntent"];
    [self.navigationController pushViewController:triggerIntent animated:YES];
    NSLog(@"YCXMenu triggerIntent");
}

-(void)triggerIntentPress{
    
    _btnTriggerIntent.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
}

- (void)updateVocab{
    
    _btnupdateVocab.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
    AITestUpdateVocab *updateVocab = [self.storyboard instantiateViewControllerWithIdentifier:@"TestUpdateVocab"];
    [self.navigationController pushViewController:updateVocab animated:YES];
    NSLog(@"YCXMenu triggerIntent");
}

-(void)updateVocabPress{
    
    _btnupdateVocab.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
}


- (void)updateWakeup{
    
    _btnUpdateWakeup.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
    updateWakeupWords *updateWakeup = [self.storyboard instantiateViewControllerWithIdentifier:@"updateWakeup"];
    [self.navigationController pushViewController:updateWakeup animated:YES];
    NSLog(@"YCXMenu triggerIntent");
}

-(void)updateWakeupPress{
    
    _btnUpdateWakeup.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
}

-(void)onCall:(NSString *)command data:(NSString *)data{
    if([command isEqualToString:@"very.good"]){
        NSLog(@"setView  very.good");
    }
}

-(void)onMessage:(NSString *)message data:(NSString *)data{
    if([message isEqualToString:@"sys.dialog.start"]){
        NSLog(@"setView  sys.dialog.start");
    }
    if([message isEqualToString:@"sys.dialog.end"]){
        NSLog(@"setView  sys.dialog.end");
        [[DDSManager shareInstance] unSubscribe:self.messageObserver];
    }
}

#pragma mark --初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    for(UIView *view in [self.view subviews]){
        [view removeFromSuperview];
    }
    
    self.commandObserver = [[CommandObserver alloc] init];
    self.commandObserver.delegate = self;
    self.messageObserver = [[MessageObserver alloc] init];
    self.messageObserver.delegate = self;

    NSArray *commandArray = [[NSArray alloc] initWithObjects:@"very.good", @"hello.good",  nil];
    [[DDSManager shareInstance] subscribe:commandArray observer:self.commandObserver];
    
    NSArray *messageArray = [[NSArray alloc] initWithObjects:@"avatar.silence", @"avatar.listening", @"avatar.understanding", @"avatar.speaking",@"avatar.standby",@"sys.dialog.start",@"sys.dialog.end",nil];//
    [[DDSManager shareInstance] subscribe:messageArray observer:self.messageObserver];
    

    UIScrollView *scr = [[UIScrollView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:scr];
    scr.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+50);
    
//    _lable1 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.origin.x+10, self.view.frame.origin.y+20, self.view.frame.size.width-100, 30)];
//    _lable1.text = @"对话模式";
    UIFont *font = [UIFont systemFontOfSize:20];
//    [_lable1 setFont:font];
//    [scr addSubview:_lable1];
//    
//    LLSwitch *llSwitch1 = [[LLSwitch alloc] initWithFrame:CGRectMake(self.view.frame.origin.x+self.view.frame.size.width-100, self.view.frame.origin.y+20, 60, 30)];
//    llSwitch1.tag = 101;
//    [scr addSubview:llSwitch1];
//    llSwitch1.delegate = self;
//    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"newSwitch1"] ==0 || [[NSUserDefaults standardUserDefaults] integerForKey:@"newSwitch1"] ==1) {
//        llSwitch1.on = [[NSUserDefaults standardUserDefaults] integerForKey:@"newSwitch1"];
//    }
//    if([[NSUserDefaults standardUserDefaults] integerForKey:@"newProductVad"] == YES && llSwitch1.on == NO){
//        llSwitch1.userInteractionEnabled =NO;
//    }else if([[NSUserDefaults standardUserDefaults] integerForKey:@"newProductVad"] == NO && llSwitch1.on == YES){
//        llSwitch1.userInteractionEnabled =NO;
//    }else if([[NSUserDefaults standardUserDefaults] integerForKey:@"newProductVad"] == NO && llSwitch1.on == NO){
//        llSwitch1.userInteractionEnabled =YES;
//    }else if([[NSUserDefaults standardUserDefaults] integerForKey:@"newProductVad"] == YES && llSwitch1.on == YES){
//        llSwitch1.userInteractionEnabled =YES;
//    }
//    
//
//
//    _lableTips1 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.origin.x+10, self.view.frame.origin.y+50, self.view.frame.size.width-120, 120)];
//    [_lableTips1 setTextColor:[UIColor darkGrayColor]];
//    NSString * Tip1text = @"开启后，进入按住说话模式，须要按住Mic说话;关闭后，进入点击说话模式，点击Mic说话";
//    _lableTips1.text = Tip1text;
//    [_lableTips1 setNumberOfLines:0];
//    [scr addSubview:_lableTips1];
//    
//    _view1 = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x+10, self.view.frame.origin.y+163, self.view.frame.size.width-30, 1)];
//    [_view1 setBackgroundColor:[UIColor darkGrayColor]];
//    [scr addSubview:_view1];
    
//    _lable2 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.origin.x+10, self.view.frame.origin.y+170, self.view.frame.size.width-100, 30)];
//    _lable2.text = @"全局唤醒开关";
//    [_lable2 setFont:font];
//    [scr addSubview:_lable2];
//    
//    LLSwitch *llSwitch2 = [[LLSwitch alloc] initWithFrame:CGRectMake(self.view.frame.origin.x+self.view.frame.size.width-100, self.view.frame.origin.y+170, 60, 30)];
//    [scr addSubview:llSwitch2];
//    llSwitch2.delegate = self;
//    llSwitch2.tag = 102;
//    //llSwitch2.on = YES;
//    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"newSwitch2"] ==0 ||[[NSUserDefaults standardUserDefaults] integerForKey:@"newSwitch2"] ==1) {
//        llSwitch2.on = [[NSUserDefaults standardUserDefaults] integerForKey:@"newSwitch2"];
//    }else{
//        [[NSUserDefaults standardUserDefaults] setInteger:YES forKey:@"newSwitch2"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        llSwitch2.on = YES;
//    }
//    
//    
//    _lableTips2 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.origin.x+10, self.view.frame.origin.y+200, self.view.frame.size.width-120, 120)];
//    [_lableTips2 setTextColor:[UIColor darkGrayColor]];
//    _lableTips2.text = @"开启后，可用唤醒词唤醒功能；关闭后，须要手动触发Mic才可对话";;
//    [_lableTips2 setNumberOfLines:0];
//    [scr addSubview:_lableTips2];
//    
//    _view2 = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x+10, self.view.frame.origin.y+313, self.view.frame.size.width-30, 1)];
//    [_view2 setBackgroundColor:[UIColor darkGrayColor]];
//    [scr addSubview:_view2];
    
//    _lable3 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.origin.x+10, self.view.frame.origin.y+400, self.view.frame.size.width-100, 30)];
//    _lable3.text = @"全局对话开关";
//    [_lable3 setFont:font];
//    [self.view addSubview:_lable3];
//    
//    LLSwitch *llSwitch3 = [[LLSwitch alloc] initWithFrame:CGRectMake(self.view.frame.origin.x+self.view.frame.size.width-100, self.view.frame.origin.y+400, 60, 30)];
//    [self.view addSubview:llSwitch3];
//    llSwitch3.delegate = self;
//    llSwitch3.tag = 103;
//    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"newSwitch3"] ==0 || [[NSUserDefaults standardUserDefaults] integerForKey:@"newSwitch3"] ==1) {
//        llSwitch3.on = [[NSUserDefaults standardUserDefaults] integerForKey:@"newSwitch3"];
//    }
//    
//    
//    _lableTips3 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.origin.x+10, self.view.frame.origin.y+430, self.view.frame.size.width-120, 90)];
//    [_lableTips3 setTextColor:[UIColor darkGrayColor]];
//    _lableTips3.text = @"开启后，进入对话模式，跳转到对话页面；关闭后，终止当前的对话，须要重新唤醒或点击Mic或重新打开对话开关";;
//    [_lableTips3 setNumberOfLines:0];
//    [self.view addSubview:_lableTips3];
//    
//    _view3 = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x+10, self.view.frame.origin.y+543, self.view.frame.size.width-30, 1)];
//    [_view3 setBackgroundColor:[UIColor darkGrayColor]];
//    [self.view addSubview:_view3];
    
//    _lable4 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.origin.x+10, self.view.frame.origin.y+20/*320*/, self.view.frame.size.width-100, 30)];
    //_lable4 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.origin.x+10, self.view.frame.origin.y+550, self.view.frame.size.width-100, 30)];
//    _lable4.text = @"场景模式";
//    [_lable4 setFont:font];
//    [scr addSubview:_lable4];
//    
//    LLSwitch *llSwitch4 = [[LLSwitch alloc] initWithFrame:CGRectMake(self.view.frame.origin.x+self.view.frame.size.width-100, self.view.frame.origin.y+20/*320*/, 60, 30)];
//    //LLSwitch *llSwitch4 = [[LLSwitch alloc] initWithFrame:CGRectMake(self.view.frame.origin.x+self.view.frame.size.width-100, self.view.frame.origin.y+550, 60, 30)];
//    [scr addSubview:llSwitch4];
//    llSwitch4.delegate = self;
//    llSwitch4.tag = 104;
//    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"newSwitch4"] ==0 ||[[NSUserDefaults standardUserDefaults] integerForKey:@"newSwitch4"] ==1) {
//        llSwitch4.on = [[NSUserDefaults standardUserDefaults] integerForKey:@"newSwitch4"];
//    }
//    
//    _lableTips4 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.origin.x+10, self.view.frame.origin.y+50/*350*/, self.view.frame.size.width-120, 120)];
//    //_lableTips4 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.origin.x+10, self.view.frame.origin.y+580, self.view.frame.size.width-120, 90)];
//    [_lableTips4 setTextColor:[UIColor darkGrayColor]];
//    _lableTips4.text = @"开启后，进入静音模式，但可正常对话；关闭后，进入正常模式";
//    [_lableTips4 setNumberOfLines:0];
//    [scr addSubview:_lableTips4];
    
    _lable1 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.origin.x+10, self.view.frame.origin.y+20, self.view.frame.size.width-100, 30)];
    _lable1.text = @"产品ID";
    [_lable1 setFont:font];
    [scr addSubview:_lable1];
    
    _lable2 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.origin.x+10, self.view.frame.origin.y+50, self.view.frame.size.width-100, 30)];
    _lable2.text = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"ProductId"];
    [_lable2 setTextColor:[UIColor grayColor]];
    [_lable2 setFont:font];
    [scr addSubview:_lable2];
    
    
    _lable3 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.origin.x+10, self.view.frame.origin.y+90, self.view.frame.size.width-100, 30)];
    _lable3.text = @"产品分支号";
    [_lable3 setFont:font];
    [scr addSubview:_lable3];
    
    _lable4 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.origin.x+10, self.view.frame.origin.y+120, self.view.frame.size.width-100, 30)];
    _lable4.text = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"AliasKey"];
    [_lable4 setTextColor:[UIColor grayColor]];
    [_lable4 setFont:font];
    [scr addSubview:_lable4];
    
    
    _view4 = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x+10, self.view.frame.origin.y+163/*463*/, self.view.frame.size.width-30, 1)];
    [_view4 setBackgroundColor:[UIColor darkGrayColor]];
    [scr addSubview:_view4];
    
    _lable5 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.origin.x+10, self.view.frame.origin.y+170/*470*/, self.view.frame.size.width-100, 30)];
    _lable5.text = @"DUI工具";
    [_lable5 setFont:font];
    [scr addSubview:_lable5];
    
    _btnTriggerIntent = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+10, self.view.frame.origin.y+210/*510*/, self.view.frame.size.width-30, 40)];
    [_btnTriggerIntent setTitle:@"触发意图" forState:UIControlStateNormal];
    [_btnTriggerIntent setTitleEdgeInsets:UIEdgeInsetsMake(0, -(_btnTriggerIntent.frame.size.width/2)*1.5, 0, 0)];
    _btnTriggerIntent.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
//    [_btnTriggerIntent.layer setMasksToBounds:YES];
//    [_btnTriggerIntent.layer setBorderWidth:1.0];
//    [_btnTriggerIntent.layer setBorderColor:[UIColor grayColor].CGColor];
    _btnTriggerIntent.titleLabel.font= [UIFont systemFontOfSize: 18];
    [_btnTriggerIntent setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_btnTriggerIntent addTarget:self action:@selector(triggerIntent) forControlEvents:UIControlEventTouchUpInside];
    [_btnTriggerIntent addTarget:self action:@selector(triggerIntentPress) forControlEvents:UIControlEventTouchDown];
    [scr addSubview:_btnTriggerIntent];
    
    
    _btnupdateVocab = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+10, self.view.frame.origin.y+260/*510*/, self.view.frame.size.width-30, 40)];
    [_btnupdateVocab setTitle:@"更新词库" forState:UIControlStateNormal];
    [_btnupdateVocab setTitleEdgeInsets:UIEdgeInsetsMake(0, -(_btnupdateVocab.frame.size.width/2)*1.5, 0, 0)];
    _btnupdateVocab.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
    _btnupdateVocab.titleLabel.font= [UIFont systemFontOfSize: 18];
    [_btnupdateVocab setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_btnupdateVocab addTarget:self action:@selector(updateVocab) forControlEvents:UIControlEventTouchUpInside];
    [_btnupdateVocab addTarget:self action:@selector(updateVocabPress) forControlEvents:UIControlEventTouchDown];
    [scr addSubview:_btnupdateVocab];
    
    
    _btnUpdate = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+10, self.view.frame.origin.y+310/*560*/, self.view.frame.size.width-30, 40)];
    [_btnUpdate setTitle:@"检查更新" forState:UIControlStateNormal];
    [_btnUpdate setTitleEdgeInsets:UIEdgeInsetsMake(0, -(_btnUpdate.frame.size.width/2)*1.5, 0, 0)];
    //[_btnUpdate setContentEdgeInsets:UIEdgeInsetsMake(50, 0, 0, 0)];
    _btnUpdate.titleLabel.font= [UIFont systemFontOfSize: 18];
    //_btnUpdate.backgroundColor = [UIColor grayColor];
    _btnUpdate.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
    [_btnUpdate setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_btnUpdate addTarget:self action:@selector(versionUpdate) forControlEvents:UIControlEventTouchUpInside];
    [_btnUpdate addTarget:self action:@selector(versionUpdatePress) forControlEvents:UIControlEventTouchDown];
    [scr addSubview:_btnUpdate];
    
    
    _btnUpdateWakeup = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+10, self.view.frame.origin.y+360/*560*/, self.view.frame.size.width-30, 40)];
    [_btnUpdateWakeup setTitle:@"副唤醒词" forState:UIControlStateNormal];
    [_btnUpdateWakeup setTitleEdgeInsets:UIEdgeInsetsMake(0, -(_btnUpdateWakeup.frame.size.width/2)*1.5, 0, 0)];
    //[_btnUpdate setContentEdgeInsets:UIEdgeInsetsMake(50, 0, 0, 0)];
    _btnUpdateWakeup.titleLabel.font= [UIFont systemFontOfSize: 18];
    //_btnUpdate.backgroundColor = [UIColor grayColor];
    _btnUpdateWakeup.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
    [_btnUpdateWakeup setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_btnUpdateWakeup addTarget:self action:@selector(updateWakeup) forControlEvents:UIControlEventTouchUpInside];
    [_btnUpdateWakeup addTarget:self action:@selector(updateWakeupPress) forControlEvents:UIControlEventTouchDown];
    [scr addSubview:_btnUpdateWakeup];
    
//    [_lableTips4 setTextColor:[UIColor darkGrayColor]];
//    
//    _lableTips4.text = @"开启后，进入静音模式，但可正常对话；关闭后，进入正常模式";
//    [_lableTips4 setNumberOfLines:0];
//    [self.view addSubview:_lableTips4];
    
    
    _lable5 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+self.view.frame.size.height-60, self.view.frame.size.width, 30)];
    _lable5.text = @"DUI Dev|AISpeech";
    [_lable5 setTextColor:[UIColor grayColor]];
    //[_lable5 setFont:font];
    [self.view addSubview:_lable5];
    //_lable5.center = CGPointMake(self.view.bounds.size.width/2,self.view.bounds.size.height/2);
    //_lable5.center = self.view.center;
    _lable5.textAlignment = NSTextAlignmentCenter;
    
    _lableTips1 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+self.view.frame.size.height-30, self.view.frame.size.width, 30)];
    NSString *str = @"版本:1.0.0";
    _lableTips1.text =  str;
    //_lableTips1.text = [str stringByAppendingString:[[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"]];//CFBundleVersion
    //_lableTips1.text = [str stringByAppendingString:version ];
    // [[NSUserDefaults standardUserDefaults] objectForKey:@"AliasKey"]];
    [_lableTips1 setTextColor:[UIColor grayColor]];
    //[_lableTips1 setFont:font];
    [self.view addSubview:_lableTips1];
    _lableTips1.textAlignment = NSTextAlignmentCenter;
    //_lable5.center = CGPointMake(self.view.bounds.size.width/2,self.view.bounds.size.height/2);
    //_lableTips1.center = self.view.center;
    

    // Do any additional setup after loading the view.
}

-(void)didTapLLSwitch:(LLSwitch *)llSwitch {
    
    if (switch1%2 == 0 && llSwitch.tag == 101) {
        //
        //if([[NSUserDefaults standardUserDefaults] synchronize] == NO){
            NSLog(@"switch1 mod 2 is 0 start1");
            switch1++;
            [self stopVad];
            [[NSUserDefaults standardUserDefaults] setInteger:YES forKey:@"newSwitch1"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            llSwitch.userInteractionEnabled = NO;
        //}
    }else if (switch1%2 == 1 && llSwitch.tag == 101) {
        //if([[NSUserDefaults standardUserDefaults] synchronize] == YES){
            //NSLog(@"switch1 mod 2 is 1 start1");
            switch1++;
            [self startVad];
            [[NSUserDefaults standardUserDefaults] setInteger:NO forKey:@"newSwitch1"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            llSwitch.userInteractionEnabled = NO;
        //}
    }
    
    if (switch2%2 == 0 && llSwitch.tag == 102) {
        NSLog(@"switch2 mod 2 is 0 start2....llSwitch.on...%d", llSwitch.on);
        switch2++;
        [[NSUserDefaults standardUserDefaults] setInteger:NO forKey:@"newSwitch2"];
        [[NSUserDefaults standardUserDefaults] synchronize];
//        dispatch_async(dispatch_get_main_queue(), ^{
//                   });
        [self stopWakeup];
    }else if (switch2%2 == 1 && llSwitch.tag == 102) {
        NSLog(@"switch2 mod 2 is 1 start2....llSwitch.on...%d", llSwitch.on);
        switch2++;
        [[NSUserDefaults standardUserDefaults] setInteger:YES forKey:@"newSwitch2"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self startWakeup];
    }
    
    //switch3 = switch3 + (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"newSwitch3Dialog"];
    if (switch3%2 == 0 && llSwitch.tag == 103) {
        NSLog(@"switch3 mod 2 is 0 start2");
        switch3++;
        [self startDialog];
        [[NSUserDefaults standardUserDefaults] setInteger:YES forKey:@"newSwitch3"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //dialogFlagSwitch = 1;
    }else if (switch3%2 == 1 && llSwitch.tag == 103) {
        NSLog(@"switch3 mod 2 is 1 start2");
        switch3++;
        [self stopDialog];
        [[NSUserDefaults standardUserDefaults] setInteger:NO forKey:@"newSwitch3"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //dialogFlagSwitch = 1;
    }
    
    if (switch4%2 == 0 && llSwitch.tag == 104) {
        NSLog(@"switch4 mod 2 is 0 start2..llSwitch.on...%d", llSwitch.on);
        switch4++;
        [self slienceMode];
        [[NSUserDefaults standardUserDefaults] setInteger:YES forKey:@"newSwitch4"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else if (switch4%2 == 1 && llSwitch.tag == 104) {
        NSLog(@"switch4 mod 2 is 1 start2..llSwitch.on...%d", llSwitch.on);
        switch4++;
        [[NSUserDefaults standardUserDefaults] setInteger:NO forKey:@"newSwitch4"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self normalMode];
    }
    
}

- (void)animationDidStopForLLSwitch:(LLSwitch *)llSwitch {
    NSLog(@"stop");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
