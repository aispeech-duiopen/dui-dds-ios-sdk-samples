//
//  AITestDUICtrl.m
//  aios
//
//  Created by speech_dui on 2017/8/21.
//  Copyright © 2017年 yuruilong. All rights reserved.
//
#import "AITestDUICtrl.h"
#import "Lottie.h"
#import "HMScannerController.h"
#import "SVProgressHUD.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <AVFoundation/AVFoundation.h>
#import "DDSConfig.h"
#import "setSwitchViewController.h"
#import "CommandObserver.h"
#import "NativeApiObserver.h"
#import "MessageObserver.h"
#import "YCXMenu.h"
#import "VolumeView.h"
#import "ASREngineManager.h"
#import "TTSEngineManager.h"
#import "TextWidget.h"
#import "ListWidget.h"
#import "SemanticRecorder.h"
#import "AuthorizationManager.h"
#import "ThirdPartTTS.h"
#import "alarmUtil.h"

static NSString * TAG = @"AITestDUICtrl";

int reStartFlag;
extern int flagState;

BOOL isA = YES;
BOOL isVad = YES;
int lottieStateVadSt = 1;

@interface AITestDUICtrl ()<ASREngineManagerDelegate, TTSEngineManagerProtocol, SemanticRecorderDelegate>
{
    UIButton *btnBack;
    NSURL * url;
    NSMutableDictionary *paramUpdate;
    UIAlertController *alertController;
    int aiosConfigItem;
    LOTAnimationView *view;
    BOOL isInStop;
    int lottieState;
    int lottieStateVadSp;
    int stateFlag;
    int stateFinshFlag;
    int volume;
    int pressFlag;
    BOOL updateFlag;
    BOOL updateFlag1;
    VolumeView *volumeView;
    NSMutableDictionary * OauthDic;
    NSMutableDictionary * OauthDicInit;
    AuthorizationManager *contact;//打电话
    ThirdPartTTS *tts;//第三方tts
}

@property (weak, nonatomic) IBOutlet UIWebView *web;
@property (strong, nonatomic) NSURLRequest * request;
@property (weak, nonatomic) IBOutlet UIButton *btnMic;
@property (nonatomic, strong) NSMutableArray *items;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btmicWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btmicHeigth;

@property(nonatomic,strong) CommandObserver *commandObserver;
@property(nonatomic,strong) NativeApiObserver *nativeApiObserver;
@property(nonatomic,strong) MessageObserver *messageObserver;
@property(nonatomic,strong) SemanticRecorder * externalRecorder;

@end

@implementation AITestDUICtrl

@synthesize items = _items;

#pragma mark - view lifecycle

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    stateFlag = 0;
    [self showState:1];
}

-(void)viewDidAppear:(BOOL)animated{
    self.web.delegate = nil;
    [self.web stopLoading];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self firstInit];
    [self authInitView];
    [self setAudioConfig];
    //打印Log
//    [DDSManager setLogEnabled:YES];
    //[DDSManager setLogWriteToFile:YES];
    
    [self afterInit];
}

#pragma mark - 初始化SDK

//初始化监听事件
-(void)firstInit{
    lottieState = 0;//动画当前状态
    reStartFlag = 1;
//    isA = YES;//按住说话时，是按下还是弹起标志，
    stateFlag = 1;//状态是否改变标志
    stateFinshFlag = 0;//动画视图完成标志
    pressFlag = 0;//按住说话标志
    volume = 0;//音量大小
    updateFlag = NO;//扫码更新标志
    updateFlag1 = NO;
    volumeView =  [[VolumeView alloc]init];//按住说话视图
    OauthDicInit = [[NSMutableDictionary alloc] init];
    OauthDic = [[NSMutableDictionary alloc] init];
    _alarmArray = [[NSMutableArray alloc] init];
    
    btnBack = [[UIButton alloc] init];
    [btnBack setTitle:@"+" forState:UIControlStateNormal];
    [btnBack setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnBack.frame = CGRectMake(0, 0, 44, 44);
    btnBack.titleLabel.font= [UIFont systemFontOfSize: 35];
    [btnBack setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 5, 0)];
    [btnBack addTarget:self action:@selector(showMenu1FromNavigationBarItem:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    self.navigationItem.rightBarButtonItem = item;
    
    [_btnMic addTarget:self action:@selector(release:) forControlEvents:UIControlEventTouchUpInside];
    [_btnMic addTarget:self action:@selector(release:) forControlEvents:UIControlEventTouchUpOutside];
    [_btnMic addTarget:self action:@selector(press:) forControlEvents:UIControlEventTouchDown];
    
    [self initbutton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomeActive) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    //添加检测app进入后台的观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name: UIApplicationDidEnterBackgroundNotification object:nil];
    
    //监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopComplete) name:@"stopComplete" object:nil];
    
}

//初始化按钮
-(void)initbutton{
    if(isA){
        stateFlag = 0;
        _btnMic.adjustsImageWhenHighlighted = NO;
        _btnMic.layer.shadowOffset =  CGSizeMake(0, 0);
        _btnMic.layer.shadowOpacity = 0;
        _btnMic.layer.shadowColor =  [UIColor whiteColor].CGColor;
        [_btnMic.layer setMasksToBounds:NO];
        [_btnMic.layer setBorderWidth:0];
        [_btnMic setTitle:@"" forState:UIControlStateNormal];
        //_btnMic.titleLabel.font= [UIFont systemFontOfSize: 50];
        _btmicWidth.constant = 100;
        _btmicHeigth.constant = 90;
        if(lottieStateVadSt)
            [self showState:lottieStateVadSt];
        else{
            [self showState:1];
        }
    }else{
        if(view){
            [view removeFromSuperview];
            view = nil;
        }
        stateFlag = 0;
        _btmicWidth.constant = 200;
        _btmicHeigth.constant = 40;
        _btnMic.layer.cornerRadius=5;
        _btnMic.adjustsImageWhenHighlighted = YES;
        _btnMic.backgroundColor = [UIColor whiteColor];
        [_btnMic.layer setMasksToBounds:YES];
        [_btnMic.layer setBorderWidth:1.0];
        [_btnMic.layer setBorderColor:[UIColor grayColor].CGColor];
        _btnMic.titleLabel.font= [UIFont systemFontOfSize: 20];
        _btnMic.titleLabel.text = @"按住 说话";
        [_btnMic setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        //[_btnMic setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btnMic setTitle:@"按住 说话" forState:UIControlStateNormal];
    }
}

//初始化授权失败的弹框
-(void)authInitView{
    
    alertController = [UIAlertController alertControllerWithTitle:@"提示信息:" message:@"授权失败，是否重新授权" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        [[DDSManager shareInstance] startAuth];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
}

//初始化音频策略
- (void)setAudioConfig{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker | AVAudioSessionCategoryOptionAllowBluetooth error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
}

//获取内部H5路径
- (void)initH5{
    NSString *path = [[DDSManager shareInstance] getValidH5Path];
    NSLog(@"pathH5 viewDid : %@", path);
    url = [[NSURL alloc] initWithString:path];
    NSLog(@"h5连接url : %@", url);
    self.request = [[NSURLRequest alloc] initWithURL:url];
    NSLog(@"h5连接loadrequest begin : %@", self.request);
    self.web.delegate = self;
    self.web.allowsInlineMediaPlayback = YES;
    self.web.mediaPlaybackRequiresUserAction = NO;
    NSLog(@"h5连接absoluteString begin : %@", self.request.URL.absoluteString);
    [self.web loadRequest:self.request];
    [self catchJsLog];
    NSLog(@"h5连接结束: %@", self.request);
}

//初始化observer对象
- (void)afterInit{
    //初始化DDSManager
    [self initDDSManager];
    
    if(!self.messageObserver){
        self.messageObserver = [[MessageObserver alloc] init];
        self.messageObserver.delegate = self;
    }
    if(!self.commandObserver){
        self.commandObserver = [[CommandObserver alloc] init];
        self.commandObserver.delegate = self;
    }
    if(!self.nativeApiObserver){
        self.nativeApiObserver = [[NativeApiObserver alloc] init];
        self.nativeApiObserver.delegate = self;
    }
}

//初始化topic
-(void) initSubscribe{
    ////参考文档https://www.dui.ai/docs/operation/#/ct_common_iOS_SDK, 功能列表一栏 响应内置消息
    NSArray *messageArray = [[NSArray alloc] initWithObjects:@"avatar.silence", @"avatar.listening", @"avatar.understanding", @"avatar.speaking",@"avatar.standby",@"sys.dialog.start",@"sys.dialog.end",@"speak.end",@"sys.vad.begin",@"sys.vad.end",@"sys.upload.result",@"sys.dialog.error",@"sys.wakeup.result",@"context.input.text",nil];
    
    NSArray *commandArray = [[NSArray alloc] initWithObjects:@"navi.route", @"sys.action.call", @"com.ileja.phone.call", @"open.window", @"open.door",@"navi.close", @"test.request", nil];
    
    NSArray *nativeApiArray = [[NSArray alloc] initWithObjects:@"sys.query.contacts",@"alarm.set", @"alarm.list", @"alarm.delete", @"com.ileja.phone.redial.notification", @"system.settings.operation", @"test.navigation", nil];
    
    [[DDSManager shareInstance] subscribe:commandArray observer:self.commandObserver];
    [[DDSManager shareInstance] subscribe:nativeApiArray observer:self.nativeApiObserver];
    [[DDSManager shareInstance] subscribe:messageArray observer:self.messageObserver];
}

//初始化DDS
- (void)initDDSManager{
    if([DDSManager getInstance]){
        [DDSManager deallocInstance];
    }
    DDSManager *manager = [DDSManager shareInstance];
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:@"278581704" forKey:K_PRODUCT_ID];//TODO 填写自己的产品ID
    [paramDic setObject:@"prod" forKey:K_ALIAS_KEY]; // TODO 填写产品的发布分支
    [paramDic setObject:@"user123" forKey:K_USER_ID];// TODO 填写自己的用户ID
    [paramDic setObject:@"2f0d470ac76d319fcc4a1d777bf65e08.zip" forKey:K_DUICORE_ZIP];// TODO填写对应的资源名称
    [paramDic setObject:@"product.zip" forKey:K_CUSTOM_ZIP];//填写对应的资源名称
    [paramDic setObject:@"profile" forKey:K_AUTH_TYPE];
    [paramDic setObject:@"9cd0f77b117fc6df5546c9055cd3a375" forKey:K_API_KEY]; // TODO 填写API KEY
    [paramDic setObject:@"7fb0c6125ae781f2b56625ba13b0b89b" forKey:K_PRODUCT_KEY];
    [paramDic setObject:@"9f0de1b0bdcb857a82ed41e4732313d9" forKey:K_PRODUCT_SECRET];
    [self test_setDDSConfig:paramDic];//设置可选配置项
    if([[paramDic allKeys] containsObject:K_RECORDER_MODE]){
        [self test_externalRecorderDelegate];
    }

//    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"newProduct"];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"newProduct"]) {
        NSDictionary * newProductDic = (NSDictionary *)[[NSUserDefaults standardUserDefaults] objectForKey:@"newProduct"];
        NSMutableDictionary *newProductDicMu = [NSMutableDictionary dictionaryWithDictionary:newProductDic];
        int serverType = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"serverType"];
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"ACCESS_TOKEN"]){
            NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"ACCESS_TOKEN"];
        }
        NSLog(@"%@, DDS start", TAG);
        [manager startWithdelegate:self DDSConfig:newProductDicMu withConfigServerType:serverType];
    }else{
        int serverType = 2;
        NSLog(@"%@, DDS start", TAG);
        [manager startWithdelegate:self DDSConfig:paramDic withConfigServerType:serverType];
        [[NSUserDefaults standardUserDefaults] setObject:paramDic forKey:@"newProduct"];
        [[NSUserDefaults standardUserDefaults] setInteger:serverType forKey:@"serverType"];
        [[NSUserDefaults standardUserDefaults] setObject:@"profile" forKey:@"AUTH_TYPE"];
        [[NSUserDefaults standardUserDefaults] setObject: [paramDic objectForKey:K_PRODUCT_ID] forKey:@"ProductId"];
        [[NSUserDefaults standardUserDefaults] setObject: [paramDic objectForKey:K_ALIAS_KEY] forKey:@"AliasKey"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

#pragma mark - 按钮事件
//显示DUI功能接口
- (void)showMenu1FromNavigationBarItem:(id)sender {
    // 通过NavigationBarItem显示Menu
    [YCXMenu setTintColor:[UIColor colorWithRed:65/256.0 green:65/256.0 blue:65/256.0 alpha:1]];
    [YCXMenu setSelectedColor:[UIColor colorWithRed:35/256.0 green:35/256.0 blue:35/256.0 alpha:1]];
    [YCXMenu setSeparatorColor:[UIColor colorWithRed:35/256.0 green:35/256.0 blue:35/256.0 alpha:1]];
    if ([YCXMenu isShow]){
        [YCXMenu dismissMenu];
    } else {//self.view.frame.size.width - 50
        [YCXMenu showMenuInView:self.view fromRect:CGRectMake(self.view.frame.origin.x+self.view.frame.size.width, 0, 50, -5) menuItems:self.items selected:^(NSInteger index, YCXMenuItem *item) {
            if((int)index == 1){
                [self setSwitch:sender];
            }
            if((int)index == 2){
                [self clickScanButton:sender];
            }
            if((int)index == 3){
                [self getWakeup:sender];
            }
            
            NSLog(@"index: %d YCXMenu  %@",(int)index,item);
        }];
    }
    //}
}

//进入设置页面接口
- (void)setSwitch:(id)sender {
    NSLog(@"YCXMenu setSwitch");
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    setSwitchViewController *setSwitch = [story instantiateViewControllerWithIdentifier:@"setSwitchViewController"];
    [self.navigationController pushViewController:setSwitch animated:YES];
}

//扫码接口
- (void)clickScanButton:(id)sender {
    
    NSString *cardName = @"DUI";
    UIImage *avatar = [UIImage imageNamed:@"avatar"];
    HMScannerController *scanner = [HMScannerController scannerWithCardName:cardName avatar:avatar completion:^(NSString *stringValue) {
        NSRange range = [stringValue rangeOfString:@"?"];
        NSRange range1 = [stringValue rangeOfString:@"#"];
        NSString *propertys = [stringValue substringWithRange:NSMakeRange(range.location+1, range1.location-range.location-1)];
        NSArray *subArray = [propertys componentsSeparatedByString:@"&"];
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
        for (int j = 0 ; j < subArray.count; j++)
        {
            NSArray *dicArray = [subArray[j] componentsSeparatedByString:@"="];
            [tempDic setObject:dicArray[1] forKey:dicArray[0]];
        }
        NSString *platform = [tempDic objectForKey:@"platform"];
        if([platform isEqualToString:@"iOS"]){
            [[DDSManager shareInstance] stop];

            NSString *productId = [tempDic objectForKey:@"productId"];
            NSString *aliasKey =  [tempDic objectForKey:@"aliasKey"];
            NSString *devTestAI = [tempDic objectForKey:@"env"];
            NSString *userId = [tempDic objectForKey:@"userId"];
            NSString *authType = [tempDic objectForKey:@"authType"];
            NSString *apikey = [tempDic objectForKey:@"apiKey"];
            aiosConfigItem = 0;
            if([devTestAI isEqualToString:@"test"]){
                aiosConfigItem = 1;
            }else if([devTestAI isEqualToString:@"dui"]){
                aiosConfigItem = 2;
            }else if([devTestAI isEqualToString:@"beta"]){
                aiosConfigItem = 3;
            }
            
            paramUpdate = [[NSMutableDictionary alloc] init];
            
            [paramUpdate setObject:productId forKey:K_PRODUCT_ID];
            [paramUpdate setObject:aliasKey forKey:K_ALIAS_KEY];
            [paramUpdate setObject:@"profile" forKey:K_AUTH_TYPE];
            [paramUpdate setObject:apikey forKey:K_API_KEY];
            [paramUpdate setObject:userId forKey:K_USER_ID];
            [paramUpdate setObject:@"2f0d470ac76d319fcc4a1d777bf65e08.zip" forKey:K_DUICORE_ZIP];
            [paramUpdate setObject:@"product.zip" forKey:K_CUSTOM_ZIP];
            
            updateFlag = YES;
            updateFlag1 = YES;
            
            if([DDSManager getInstance]) {
                [DDSManager deallocInstance];
            }
            
            DDSManager * manager = [DDSManager shareInstance];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [manager startWithdelegate:self DDSConfig:paramUpdate withConfigServerType:aiosConfigItem];
                });
            });
            NSLog(@"update product");
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [[[DDSManager shareInstance] getTTSInstance] speak:@"请选择IOS平台的产品" priority:1 ttsId:@"1000"];
            });
            
        }
        
    }];
    NSLog(@"scance end---------");
    [scanner setTitleColor:[UIColor whiteColor] tintColor:[UIColor greenColor]];
    [self showDetailViewController:scanner sender:nil];
}


//获取唤醒词，以指定格式显示
- (void)getWakeup:(id)sender {
    DDSManager *manager = [DDSManager shareInstance];
    NSMutableArray *arr = [manager getWakeupWords];
    NSString *minWakeupWords = [[DDSManager shareInstance] getMinorWakeupWord];
    NSString *strData;
    if([arr count] == 1){
        strData = [[NSString alloc] initWithString:[arr componentsJoinedByString:@""]];
    }else{
        strData = [[NSString alloc] initWithString:[arr componentsJoinedByString:@"”或“"]];
    }
    if(minWakeupWords != nil){
        strData = [strData stringByAppendingFormat:@"%@%@%@", @"”或“",minWakeupWords,@"”"];
        NSString *strMin = @"“";
        strData = [strMin stringByAppendingString:strData];
    }
    [SVProgressHUD showSuccessWithStatus:strData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [SVProgressHUD dismiss];
    });
    NSLog(@"YCXMenu getWorkup");
}

//DUI控制台未配VAD,调用此方法，结束说话
- (void)release:(id)sender {
    if(isA)
    {
        [[DDSManager shareInstance] avatarClick];
    }
    else{
        /// 释放按键接口
        [self performSelector:@selector(releaseSend) withObject:self afterDelay:0.5];
        _btnMic.backgroundColor = [UIColor whiteColor];
        [_btnMic setTitle:@"按住 说话" forState:UIControlStateNormal];
        _btnMic.titleLabel.font= [UIFont systemFontOfSize: 20];
        _btnMic.titleLabel.text = @"按住 说话";
        pressFlag = 0;
        [volumeView hide];
        _btnMic.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//居中
        NSLog(@"--------1释放按键接口");
    }
}

-(void)releaseSend{
    [[DDSManager shareInstance] avatarRelease];
}

//DUI控制台未配VAD,调用此方法，开始说话
- (void)press:(id)sender {
    NSLog(@"YCXMenu actionChange");
    if(isA)
    {
        NSLog(@"YCXMenu startVad press");
    }
    else{
        /// 按下按键接口
        
        [[DDSManager shareInstance] avatarPress];
        [volumeView show];
        pressFlag = 1;
        _btnMic.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
        [_btnMic setTitle:@"松开 结束" forState:UIControlStateNormal];
        _btnMic.titleLabel.font= [UIFont systemFontOfSize: 20];
        _btnMic.titleLabel.text = @"松开 结束";
        _btnMic.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//居中
    }
}

//进入前台调用此方法
- (void)applicationBecomeActive{
    if(view){
        [view removeFromSuperview];
        view = nil;
    }
    stateFlag = 0;
    [self showState:1];
    
    
    if(reStartFlag == 0) {
        if([DDSManager getInstance]) {
            [DDSManager deallocInstance];
        }
        DDSManager *manager = [DDSManager shareInstance];
        NSDictionary * newProductDic = (NSDictionary *)[[NSUserDefaults standardUserDefaults] objectForKey:@"newProduct"];
        NSMutableDictionary *newProductDicMu = [NSMutableDictionary dictionaryWithDictionary:newProductDic];
        int serverType = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"serverType"];
        [[NSUserDefaults standardUserDefaults] synchronize];
//        [manager startWithdelegate:self DDSConfig:newProductDicMu withConfigServerType:serverType];
        [self showState:1];
        reStartFlag = 1;
    }
}

//进入后台调用此方法
- (void)applicationEnterBackground{
    
    DDSManager *manager = [DDSManager shareInstance];
    if(reStartFlag == 1) {
//        [manager stop];
        reStartFlag = 0;
    }
}

//DDS释放完成,调用此方法
-(void)stopComplete
{
//    [self setAudioConfig];
//    [self initDDSManager];
    NSLog(@"接收通知 不带参数的消息");
}

- (void)logout:(id)sender {
    NSLog(@"YCXMenu logout");
    exit(0);
}

#pragma mark - AIUtil function
-(void)showState:(int)state{
    if(!isA){
        if(pressFlag == 1){
            [volumeView setProgress:volume/100.0];
        }
    }
    
    if(stateFlag == 1 && lottieState == state)
        return;
    if(view){
        [view removeFromSuperview];
        stateFinshFlag = 0;
        view = nil;
    }
    if (state == 1){
        view =[LOTAnimationView animationNamed:@"2唤醒循环"];
    }
    if (state == 2){
        view =[LOTAnimationView animationNamed:@"4倾听循环"];
    }
    if (state == 3){
        view =[LOTAnimationView animationNamed:@"5识别循环"];
    }
    if (state == 4){
        view =[LOTAnimationView animationNamed:@"6播报循环"];
    }
    stateFlag = 1;
    lottieState = state;
    if(isA) {
        view.contentMode = UIViewContentModeScaleToFill;
        view.frame = CGRectMake(0, 10, 100, 90);
        view.loopAnimation = YES;
        //view.animationSpeed = 1;
        view.userInteractionEnabled = NO;
        self.btnMic.userInteractionEnabled = YES;
        [self.btnMic addSubview:view];
        lottieStateVadSt = state;
        [view playWithCompletion:^(BOOL animationFinished) {
            // Do Something
            NSLog(@"playFinsh %d", state);
            stateFinshFlag = 1;
        }];
    }else {
        lottieStateVadSp = state;
    }
}

-(void)sendHiMessage{
    NSMutableArray *wakeupWords = [[DDSManager shareInstance] getWakeupWords];
    NSString *minWakeupWords = [[DDSManager shareInstance] getMinorWakeupWord];
    NSLog(@"%@, sendHimessage, vad:%d", TAG, isVad);
    if(isVad){
        NSLog(@"%@, sendHimessage, words:%lu", TAG, (unsigned long)[wakeupWords count]);
        if([wakeupWords count]){
            NSString *strData;
            if([wakeupWords count] == 1){
                strData = [[NSString alloc] initWithString:[wakeupWords componentsJoinedByString:@""]];
            }else{
                strData = [[NSString alloc] initWithString:[wakeupWords componentsJoinedByString:@"或"]];
            }
            if(minWakeupWords != nil){
                strData = [strData stringByAppendingFormat:@"%@%@", @"”或“",minWakeupWords];
            }
            NSString * wake = @"Hi，主人！请用“";
            NSString * words = [[NSString alloc] initWithString:[wake stringByAppendingFormat:@"%@%@", strData ,@"”来唤醒我"]];
            NSMutableDictionary * wordsDic = [[NSMutableDictionary alloc] init];
            [wordsDic setObject:words forKey:@"text"];
            NSMutableArray * data = [[NSMutableArray alloc] init];
            [data addObject:[self dataTOjsonString:wordsDic]];
            [[DDSManager shareInstance] publishTopic:@"context.output.text" list:data];
            NSLog(@"data message-----:%@", data[0]);
        }
    }else{
        NSMutableDictionary * wordsDic = [[NSMutableDictionary alloc] init];
        [wordsDic setObject:@"Hi，主人！请你“按住Mic”与我交流" forKey:@"text"];
        NSMutableArray * data = [[NSMutableArray alloc] init];
        [data addObject:[self dataTOjsonString:wordsDic]];
        [[DDSManager shareInstance] publishTopic:@"context.output.text" list:data];
    }
}

-(NSString*)dataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSLog(@"jsonString:  %@", jsonString);
    return jsonString;
}

- (NSMutableDictionary*)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                               options:NSJSONReadingMutableContainers
                                                                 error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

-(BOOL)getVad{
    NSMutableArray* arr = [[DDSManager shareInstance] rpcURL:@"/local_keys/global_config" list:@[@"get"]];
    NSData * receiveData;
    if([arr count]){
        receiveData = arr[0];
        //获得的json先转换成字符串
        
        NSString *receiveStr = [[NSString alloc]initWithData:receiveData encoding:NSUTF8StringEncoding];
        
        //字符串再生成NSData
        
        NSData * data = [receiveStr dataUsingEncoding:NSUTF8StringEncoding];
        
        //再解析
        
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        if([jsonDict objectForKey:@"vad"]){
            NSDictionary * dic1 = [jsonDict objectForKey:@"vad"];
            if([dic1 objectForKey:@"enable"]){
                BOOL enable = [[dic1 objectForKey:@"enable"] integerValue];
                if(enable){
                    return YES;
                }
            }
        }
    }
    return NO;
}

//对话中关闭识别
-(void)freezeDialog{
    NSLog(@"freeze dialog");
    NSMutableArray * data = [[NSMutableArray alloc] init];
    [data addObject:@"freeze"];
    [[DDSManager shareInstance] publishTopic:@"dialog.ctrl" list:data];
}

//对话中恢复识别
-(void)resumeDialog{
    NSLog(@"resume dialog");
    NSMutableArray * data = [[NSMutableArray alloc] init];
    [data addObject:@"resume"];
    [[DDSManager shareInstance] publishTopic:@"dialog.ctrl" list:data];
}

- (void)catchJsLog{
    //if(DEBUG){
    JSContext *ctx = [self.web valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    NSLog(@"H5  log information");
    ctx[@"console"][@"log"] = ^(JSValue * msg) {
        NSLog(@"H5  log : %@", msg);
    };
    ctx[@"console"][@"info"] = ^(JSValue * msg) {
        NSLog(@"H5  info : %@", msg);
    };
    ctx[@"console"][@"warn"] = ^(JSValue * msg) {
        NSLog(@"H5  warn : %@", msg);
    };
    ctx[@"console"][@"error"] = ^(JSValue * msg) {
        NSLog(@"H5  error : %@", msg);
    };
    // }
}

//设置外部录音机的delegate
-(void)test_externalRecorderDelegate{
    self.externalRecorder = [[SemanticRecorder alloc] init];
    self.externalRecorder.semanticRecorderDelegate = self;
}

//打开外部录音机，开始录音
-(void)test_startExternalRecorder{
    [self.externalRecorder startRecording];
}

//关闭外部录音机，停止录音
-(void)test_stopExternalRecorder{
    [self.externalRecorder stopRecording];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//获取Documents目录路径：
-(NSString *) getDocuments{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

//获取Library目录路径
-(NSString *)getLibrary{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryDirectory = [paths objectAtIndex:0];
    return libraryDirectory;
}

//获取Library/Caches目录路径
-(NSString *)getCache{
    NSArray *cacPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [cacPath objectAtIndex:0];
    return cachePath;
}

//获取Tmp目录路径
-(NSString *)getTmp{
    NSString *tmpDirectory = NSTemporaryDirectory();
    return tmpDirectory;
}



//创建文件夹/目录(返回创建结果)
-(BOOL)createDir:(NSString *)fileName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString * path = [NSString stringWithFormat:@"%@/%@",documentsDirectory,fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    if  (![fileManager fileExistsAtPath:path isDirectory:&isDir]) {//先判断目录是否存在，不存在才创建
        BOOL res=[fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        return res;
    } else{
        return NO;
    }
}
    
//创建文件(返回创建结果)
-(BOOL)createFile:(NSString *)path data:(NSData*)data{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *testPath = [path stringByAppendingPathComponent:@"test.c"];//在传入的路径下创建test.c文件
    BOOL res=[fileManager createFileAtPath:testPath contents:nil attributes:nil];
    //通过data创建数据
    [fileManager createFileAtPath:testPath contents:data attributes:nil];
    return res;
}

//写数据到文件(返回写入结果)
-(BOOL)writeFile:(NSString *)path data:(NSString*)content{
    NSString *testPath = [path stringByAppendingPathComponent:@"test.c"];
    //NSString *content=@"将数据写入到文件！";
    BOOL res=[content writeToFile:testPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    return res;
}

//读文件数据
-(NSString*)readFile:(NSString *)path{
    //方法1:
    NSData * data = [NSData dataWithContentsOfFile:path];
    NSString * content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //方法2:
//    NSString * content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"文件读取成功: %@",content);
    return content;
}

//文件属性
-(void)fileAttriutes:(NSString *)path{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:path error:nil];
    NSArray *keys;
    id key, value;
    keys = [fileAttributes allKeys];
    int count = [keys count];
    for (int i = 0; i < count; i++)
    {
        key = [keys objectAtIndex: i];  //获取文件名
        value = [fileAttributes objectForKey: key];  //获取文件属性
    }
}

//根据路径删除文件(返回删除结果)
-(BOOL)deleteFileByPath:(NSString *)path{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL res=[fileManager removeItemAtPath:path error:nil];
    NSLog(@"文件是否存在: %@",[fileManager isExecutableFileAtPath:path]?@"YES":@"NO");
    return res;
}

//根据文件名删除文件
- (BOOL)deleteFileByName:(NSString *)name{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL res= [fileManager removeItemAtPath:[self getLocalFilePath:name] error:nil];//getLocalFilePath方法在下面
    return res;
}

    //根据路径复制文件
-(BOOL)copyFile:(NSString *)path topath:(NSString *)topath
{
    
    BOOL result = NO;
    NSError * error = nil;
    
    result = [[NSFileManager defaultManager]copyItemAtPath:path toPath:topath error:&error ];
    
    if (error){
        NSLog(@"copy失败：%@",[error localizedDescription]);
    }
    return result;
}

//根据路径剪切文件
-(BOOL)cutFile:(NSString *)path topath:(NSString *)topath
{
    
    BOOL result = NO;
    NSError * error = nil;
    result = [[NSFileManager defaultManager]moveItemAtPath:path toPath:topath error:&error ];
    if (error){
        NSLog(@"cut失败：%@",[error localizedDescription]);
    }
    return result;
    
}
//根据文件名获取资源文件路径
-(NSString *)getResourcesFile:(NSString *)fileName
{
    return [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
}

//根据文件名获取文件路径
-(NSString *)getLocalFilePath:(NSString *) fileName
{
    NSString * path = [NSHomeDirectory() stringByAppendingPathComponent:@"/Documents"];
    return [NSString stringWithFormat:@"%@/%@",path,fileName];
}

//根据文件路径获取文件名称
-(NSString *)getFileNameByPath:(NSString *)filepath
{
    NSArray *array=[filepath componentsSeparatedByString:@"/"];
    if (array.count==0) return filepath;
    return [array objectAtIndex:array.count-1];
}

//根据路径获取该路径下所有目录
-(NSArray *)getAllFileByName:(NSString *)path
{
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    NSArray *array = [defaultManager contentsOfDirectoryAtPath:path error:nil];
    return array;
}
    
//根据路径获取文件目录下所有文件
-(NSArray *)getAllFloderByName:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray * fileAndFloderArr = [self getAllFileByName:path];
    
    NSMutableArray *dirArray = [[NSMutableArray alloc] init];
    BOOL isDir = NO;
    //在上面那段程序中获得的fileList中列出文件夹名
    for (NSString * file in fileAndFloderArr){
        
        NSString *paths = [path stringByAppendingPathComponent:file];
        [fileManager fileExistsAtPath:paths isDirectory:(&isDir)];
        if (isDir) {
            [dirArray addObject:file];
        }
        isDir = NO;
    }
    return dirArray;
}
    
//获取文件及目录的大小
-(float)sizeOfDirectory:(NSString *)dir{
    NSDirectoryEnumerator *direnum = [[NSFileManager defaultManager] enumeratorAtPath:dir];
    NSString *pname;
    int64_t s=0;
    while (pname = [direnum nextObject]){
        //NSLog(@"pname   %@",pname);
        NSDictionary *currentdict=[direnum fileAttributes];
        NSString *filesize=[NSString stringWithFormat:@"%@",[currentdict objectForKey:NSFileSize]];
        NSString *filetype=[currentdict objectForKey:NSFileType];
        
        if([filetype isEqualToString:NSFileTypeDirectory]) continue;
        s=s+[filesize longLongValue];
    }
    return s*1.0;
}
    
//重命名文件或目录
-(BOOL)renameFileName:(NSString*)kDSRoot oriOldName:(NSString *)oldName toNewName:(NSString *)newName
{
    
    BOOL result = NO;
    NSError * error = nil;
    result = [[NSFileManager defaultManager] moveItemAtPath:[kDSRoot stringByAppendingPathComponent:oldName] toPath:[kDSRoot stringByAppendingPathComponent:newName] error:&error];
    
    if (error){
        NSLog(@"重命名失败：%@",[error localizedDescription]);
    }
    
    return result;
}

//读取文件
-(NSData *)readFileContent:(NSString *)filePath{
    
    return [[NSFileManager defaultManager] contentsAtPath:filePath];
}
    
//保存文件
-(BOOL)saveToDirectory:(NSString *)path data:(NSData *)data name:(NSString *)newName

{
    NSString * resultPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",newName]];
    return [[NSFileManager defaultManager] createFileAtPath:resultPath contents:data attributes:nil];
}

#pragma mark - setter/getter
- (NSMutableArray *)items {
    if (!_items) {
        
        // set title
        YCXMenuItem *menuTitle = [YCXMenuItem menuTitle:@"Menu" WithIcon:nil];
        menuTitle.foreColor = [UIColor whiteColor];
        menuTitle.titleFont = [UIFont boldSystemFontOfSize:30.0f];
        
        //set logout button
        YCXMenuItem *logoutItem = [YCXMenuItem menuItem:@"App退出" image:nil target:self action:@selector(logout:)];
        logoutItem.foreColor = [UIColor whiteColor];
        logoutItem.alignment = NSTextAlignmentCenter;
        
        //set item
        _items = [@[menuTitle,
                    [YCXMenuItem menuItem:@"设 置           "
                                    image:nil
                                      tag:100
                                 userInfo:@{@"title":@"Menu"}],
                    [YCXMenuItem menuItem:@"扫一扫           "
                                    image:nil
                                      tag:101
                                 userInfo:@{@"title":@"Menu"}],
                    [YCXMenuItem menuItem:@"唤醒词           "
                                    image:nil
                                      tag:102
                                 userInfo:@{@"title":@"Menu"}],
//
                    //logoutItem
                    ] mutableCopy];
    }
    return _items;
}

- (void)setItems:(NSMutableArray *)items {
    _items = items;
}

#pragma mark- test DDS 支持的可选配置项实例
//参考文档https://www.dui.ai/docs/operation/#/ct_common_iOS_SDK, 参数与配置一栏
-(void)test_setDDSConfig:(NSMutableDictionary*)params{
//    //partner(将唤醒结果传递给partner，不进入对话)、dialog(将唤醒结果传递给dui，进入对话),默认dialog
//    [params setObject:@"partner" forKey:K_WAKEUP_ROUTER];
    
//    //partner(将识别结果传递给partner，不进入对话)、dialog(将识别结果传递给dui，进入对话),默认dialog
//    [params setObject:@"partner" forKey:K_ASR_ROUTER];
    
//    //external(使用外置TTS引擎，需主动注册TTS请求监听器)、internal(使用内置TTS引擎),默认internal
//    [params setObject:@"external" forKey:K_TTS_MODE];
    
//    //external(使用外置录音机，需主动调用拾音接口)、internal(使用内置录音机，DDS自动录音),默认internal
//    [params setObject:@"external" forKey:K_RECORDER_MODE];
    
//    //自定义错误播放的内容，键值参考错误码https://www.dui.ai/docs/operation/#/ct_common_iOS_SDK, 错误码描述一栏
//    [params setObject:[self dataTOjsonString:@{@"71307":@"没有此说法，请换一种说法"}] forKey:K_CUSTOM_TIPS];
    
//    //关闭识别提示音
//    [params setObject:@"false" forKey:K_ASR_TIPS];
    
//    //关闭错误提示音
//    [params setObject:@"true" forKey:K_CLOSE_TIPS];
    
    //是否启用缓存
//    [params setObject:@"true" forKey:K_TTS_CACHE];
    
//    //缓存数量
//    [params setObject:[NSNumber numberWithInt:3] forKey:@"CACHE_COUNT"];
    
//    //日志级别
//    [params setObject:[NSNumber numberWithInt:1] forKey:K_LOG_LEVEL];
//    [params setObject:[NSNumber numberWithInt:0] forKey:@"BUSCLIENT_LOG_LEVEL"];//设置busclient日志级别，一般只输出错误信息
//    [params setObject:@"true" forKey:@"DEBUG_MODE"];
    
//    //自定义音频文件，仅文字匹配
//    [params setObject:@"vague" forKey:K_CUSTOM_AUDIO_MODE];

    //自定义音频文件
//    NSMutableArray * array = [[NSMutableArray alloc] init];
//    NSMutableDictionary * pcmDic = [[NSMutableDictionary alloc] init];
//    NSString * pcmPath = [self getResourcesFile:@"nhxc.pcm"];
//    [pcmDic setObject:@"开始为您播放" forKey:@"name"];
//    [pcmDic setObject:@"pcm" forKey:@"type"];
//    [pcmDic setObject:pcmPath forKey:@"path"];
//    [array addObject:pcmDic];
//
//    NSMutableDictionary * mp3Dic = [[NSMutableDictionary alloc] init];
//    NSString * mp3Path = [self getResourcesFile:@"zaine.mp3"];
//    [mp3Dic setObject:@"我在，有什么可以帮你" forKey:@"name"];
//    [mp3Dic setObject:@"mp3" forKey:@"type"];
//    [mp3Dic setObject:mp3Path forKey:@"path"];
//    [array addObject:mp3Dic];
//
//    NSMutableDictionary * wavDic = [[NSMutableDictionary alloc] init];
//    NSString * wavPath =[self getResourcesFile:@"xiaole.wav"];
//    [wavDic setObject:@"为您播放" forKey:@"name"];
//    [wavDic setObject:@"wav" forKey:@"type"];
//    [wavDic setObject:wavPath forKey:@"path"];
//    [array addObject:wavDic];
//
//    NSString * pcmJson = [[self dataTOjsonString:array] stringByReplacingOccurrencesOfString:@"\\" withString:@""];
//    [params setObject:pcmJson forKey:K_CUSTOM_AUDIO];
    
//    //配置外部使用AEC
//    [params setObject:@"external" forKey:K_AEC_MODE];
    
//    //VAD静音检测超时时间，默认8000毫秒
//    [params setObject:[NSNumber numberWithInt:4000] forKey:K_VAD_TIMEOUT];
    
//    //识别结果是否带标点符号,true识别带标点，false识别不带标点，默认为false
//    [params setObject:@"true" forKey:K_ASR_ENABLE_PUNCTUATION];

//    //是否开启音频压缩,speex|opus|false,配置为opus则使用第三方引擎接口feedOpus,默认speex,线上环境暂不支持opus配置
//    [params setObject:@"opus" forKey:K_AUDIO_COMPRESS];
}

#pragma mark- test DDS接口实例
//参考文档https://www.dui.ai/docs/operation/#/ct_common_iOS_SDK, 功能列表一栏

//打开唤醒
-(void)test_enableWakeup{
    [[[DDSManager shareInstance] getDDSWakeupEngineManager] enableWakeup];
    NSLog(@"%@, 唤醒打开了", TAG);
}

//关闭唤醒
-(void)test_disableWakeup{
    [[[DDSManager shareInstance] getDDSWakeupEngineManager] disableWakeup];
    NSLog(@"%@, 唤醒关闭了", TAG);
}

//获取唤醒词
-(void)test_getWakeupWords{
    NSMutableArray *arr = [[[DDSManager shareInstance] getDDSWakeupEngineManager] getWakeupWords];
    for (int i=0; i<[arr count]; i++) {
        NSLog(@"%@, 唤醒词个数:%lu, 第%d个是%@", TAG, (unsigned long)[arr count], i, arr[i]);
    }
}

//打开对话
-(void)test_startDialog{
    [[DDSManager shareInstance] startDialog];
    NSLog(@"%@, 对话打开了", TAG);
}

//关闭对话
-(void)test_stopDialog{
    [[DDSManager shareInstance] stopDialog];
    NSLog(@"%@, 对话关闭了", TAG);
}

//点击唤醒，停止识别，打断播报
-(void)test_avatarClick{
    [[DDSManager shareInstance] avatarClick];
    NSLog(@"%@, 点击唤醒了", TAG);
}

//点击唤醒，停止识别，打断播报, 附带一条欢迎语
-(void)test_greeting_avatarClick{
    [[DDSManager shareInstance] avatarClick:@"大家好，我来了"];
    NSLog(@"%@, 点击唤醒了,附带欢迎语", TAG);
}

//按住接口说话
-(void)test_avatarPress{
    [[DDSManager shareInstance] avatarPress];
    NSLog(@"%@, 按住接口说话，即进入对话了", TAG);
}

//释放接口结束说话，与按住接口说话匹配使用
-(void)test_avatarRelease{
    [[DDSManager shareInstance] avatarRelease];
    NSLog(@"%@, 释放接口结束说话，即退出对话了", TAG);
}

//语音播报，对话管理以外的服务，即在对话过程中禁止使用
-(void)test_speak{
    [[[DDSManager shareInstance] getTTSInstance] speak:@"对话过程中禁止调用speak" priority:1 ttsId:@"test_speak"];
    NSLog(@"%@, 播报接口调用了", TAG);
}

//停止播报，与speak匹配使用
-(void)test_shutup{
    [[[DDSManager shareInstance] getTTSInstance] shutup:@"test_speak"];
    NSLog(@"%@, 停止播报接口调用了", TAG);
}

//获取内置H5
-(void)test_getValidH5Path{
    NSString * path = [[DDSManager shareInstance] getValidH5Path];
    NSLog(@"%@, H5路径：%@", TAG, path);
}

//外部录音机接口，必须将配置项K_RECORDER_MODE设为external
-(void)test_feedPcm:(NSData*)pcm{
//    NSString * dataPath = [[NSBundle mainBundle] pathForResource:@"nhxc.pcm" ofType:nil];
//    NSData * data = [NSData dataWithContentsOfFile:dataPath];
    [[DDSManager shareInstance] feedPcm:pcm];
    NSLog(@"%@, 外部录音接口feedPcm调用了", TAG);
}

//外部录音机接口，必须将配置项K_RECORDER_MODE设为external
-(void)test_feedOpus:(NSData*)opus{
    //    NSString * dataPath = [[NSBundle mainBundle] pathForResource:@"nhxl.opus" ofType:nil];
    //    NSData * data = [NSData dataWithContentsOfFile:dataPath];
    [[DDSManager shareInstance] feedOpus:opus];
    NSLog(@"%@, 外部录音接口feedOpus调用了", TAG);
}

//外部TTS接口，播报结束通知,第三方引擎播报结束后需要调用
-(void)test_notifyTTSEnd{
    [[DDSManager shareInstance] notifyTTSEnd];
    NSLog(@"%@, 外部TTS播报完成接口调用了", TAG);
}

//场景模式，设置正常模式, 参数：1，正常模式；0，静音模式
-(void)test_normal_setDDSMode{
    [[DDSManager shareInstance] setDDSMode:1];
    NSLog(@"%@, 场景模式调用了，设置正常模式", TAG);
}

//场景模式，设置静音模式, 参数：1，正常模式；0，静音模式
-(void)test_quiet_setDDSMode{
    [[DDSManager shareInstance] setDDSMode:0];
    NSLog(@"%@, 场景模式调用了，设置静音模式", TAG);
}
//触发指定意图
-(void)test_triggerIntent{
    NSMutableDictionary *arrDic = [[NSMutableDictionary alloc] init];
    [arrDic setObject:@"吴奇隆" forKey:@"歌手名"];
    //[arrDic setObject:@"祝你一路顺风" forKey:@"歌曲名"];
    [[DDSManager shareInstance] triggerIntent:@"车萝卜电话大屏版" task:@"打电话" intent:@"拨号失败" slots:nil];
    NSLog(@"%@, 触发指定意图接口调用了", TAG);
}

//更新词库
-(void)test_updateVocabs{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    [arr addObject:@"苏州电视台"];
    [arr addObject:@"思必驰"];
    NSString * reqId = [[DDSManager shareInstance]updateVocab:@"sys.歌手名" contents:arr addOrDelete:YES];
    NSLog(@"%@, 更新词库接口调用了, 请求的ID:%@", TAG, reqId);
}

//更新词库
-(void)test_clearUpdateVocabs{
    NSString * reqId = [[DDSManager shareInstance]updateVocab:@"sys.歌手名" contents:nil addOrDelete:NO];
    NSLog(@"%@, 清空词库接口调用了, 请求的ID:%@", TAG, reqId);
}

//更新联系人
-(void)test_updateVocabs_contacts{
    contact = [[AuthorizationManager alloc] init];
    [contact getmyAddressbook];
    NSArray * arrayName = [contact.myDict allKeys];
    [[DDSManager shareInstance]updateVocab:@"sys.联系人" contents:nil addOrDelete:NO];
    NSString * reqId = [[DDSManager shareInstance]updateVocab:@"sys.联系人" contents:arrayName addOrDelete:YES];
    NSArray * arrayNumber = [contact.myDict allValues];
    NSLog(@"%@, 更新联系人词库接口调用了, 请求的ID:%@, data:%@", TAG, reqId, [self dataTOjsonString:arrayName]);
    NSString * reqIdNumber = [[DDSManager shareInstance]updateVocab:@"sys.电话号码" contents:arrayNumber addOrDelete:YES];
    NSLog(@"%@, 更新电话号码词库接口调用了, 请求的ID:%@, data:%@", TAG, reqIdNumber,[self dataTOjsonString:arrayNumber]);
}

//更新副唤醒词
-(void)test_updateMinorWakeupWord{
    NSMutableArray * array = [[NSMutableArray alloc] init];
    [array addObject:@"大白来了"];
    [[DDSManager shareInstance] updateMinorWakeupWord:@"你好大白" pinyin:@"ni hao da bai" threshold:@"0.127" greetings:array];
    NSLog(@"%@, 更新副唤醒词接口调用了", TAG);
}

//获取副唤醒词
-(void)test_getMinorWakeupWord{
    NSString * wakeupWords = [[[DDSManager shareInstance] getDDSWakeupEngineManager] getMinorWakeupWord];
    NSLog(@"%@, 副唤醒词:%@", TAG, wakeupWords);
}

//更新命令唤醒词,subscribe订阅open.window，在onCall回调中响应
-(void)test_updateCommandWakeupWord{
    NSMutableArray * arrayAction = [[NSMutableArray alloc] init];
    [arrayAction addObject:@"open.window"];
    NSMutableArray * arrayWords = [[NSMutableArray alloc] init];
    [arrayWords addObject:@"打开窗户"];
    NSMutableArray * arrayPinyins = [[NSMutableArray alloc] init];
    [arrayPinyins addObject:@"da kai chuang hu"];
    NSMutableArray * arrayThresholds = [[NSMutableArray alloc] init];
    [arrayThresholds addObject:@"0.124"];
    NSMutableArray * arrayGreetings = [[NSMutableArray alloc] init];
    [arrayGreetings addObject:@[@"窗户打开了", @"开了开了"]];
    [[DDSManager shareInstance] updateCommandWakeupWord:arrayAction words:arrayWords pinyin:arrayPinyins threshold:arrayThresholds greetings:arrayGreetings];
    NSLog(@"%@, 更新命令唤醒词接口调用了", TAG);
}

//清空当前命令唤醒词
-(void)test_clearCommandWakeupWord{
    [[[DDSManager shareInstance] getDDSWakeupEngineManager]  clearCommandWakeupWord];
    NSLog(@"%@, 清空命令唤醒词接口调用了", TAG);
}

//添加指定的命令唤醒词组，subscribe订阅open.door，在onCall回调中响应
-(void)test_addCommandWakeupWord{
    NSMutableArray * arrayAction = [[NSMutableArray alloc] init];
    [arrayAction addObject:@"open.door"];
    NSMutableArray * arrayWords = [[NSMutableArray alloc] init];
    [arrayWords addObject:@"打开门"];
    NSMutableArray * arrayPinyins = [[NSMutableArray alloc] init];
    [arrayPinyins addObject:@"da kai men"];
    NSMutableArray * arrayThresholds = [[NSMutableArray alloc] init];
    [arrayThresholds addObject:@"0.125"];
    NSMutableArray * arrayGreetings = [[NSMutableArray alloc] init];
    [arrayGreetings addObject:@[@"门打开了", @"好了好了"]];
    [[[DDSManager shareInstance] getDDSWakeupEngineManager]  addCommandWakeupWord:arrayAction words:arrayWords pinyin:arrayPinyins threshold:arrayThresholds greetings:arrayGreetings];
    NSLog(@"%@, 增加命令唤醒词接口调用了", TAG);
}

//移除指定的命令唤醒词组
-(void)test_removeCommandWakeupWord{
    NSMutableArray * arrayWords = [[NSMutableArray alloc] init];
    [arrayWords addObject:@"打开门"];
    [[[DDSManager shareInstance] getDDSWakeupEngineManager] removeCommandWakeupWord:arrayWords];
    NSLog(@"%@, 移除指定的命令唤醒词调用了", TAG);
}

//输入文本进行对话
-(void)test_sendText{
    [[DDSManager shareInstance] sendText:@"放首歌听听"];
    NSLog(@"%@, 输入文本接口调用了", TAG);
}

//设置VAD后端停顿时间
-(void)test_setVadPauseTime{
    [[DDSManager shareInstance] setVadPauseTime:400];
    NSLog(@"%@, 设置vad后端停顿时间接口调用了", TAG);
}

//获取VAD后端停顿时间
-(void)test_getVadPauseTime{
    long data = [[DDSManager shareInstance] getVadPauseTime];
    NSLog(@"%@, vad后端停顿时间:%lu", TAG, data);
}

//数据点上传
-(void)test_updateDeviceInfo{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"disconnected" forKey:@"state"];
    NSMutableDictionary *dicData = [[NSMutableDictionary alloc] init];
    [dicData setObject:dic forKey:@"bluetooth"];
    NSString * reqId = [[DDSManager shareInstance] updateDeviceInfo:dicData];
    NSLog(@"%@，数据点上传接口调用了，请求ID:%@", TAG, reqId);
}

//获取数据点数据
-(void)test_getDeviceInfo{
    NSString * data = [[DDSManager shareInstance] getDeviceInfo];
    NSLog(@"%@, 数据点数据:%@", TAG, data);
}

//开启识别
-(void)test_startListening{
    [[[DDSManager shareInstance] getASRInstance] startListening:self];
    NSLog(@"%@, 开启识别接口调用了", TAG);
}

//结束本次识别
-(void)test_stopListening{
    [[[DDSManager shareInstance] getASRInstance] stopListening];
    NSLog(@"%@, 结束本次识别接口调用了", TAG);
}

//取消本次识别
-(void)test_cancel{
    [[[DDSManager shareInstance] getASRInstance] cancel];
    NSLog(@"%@, 取消本次识别接口调用了", TAG);
}

//设置TTS委托
-(void)test_setTTSEngienManagerDelegate{
    [[[DDSManager shareInstance] getTTSInstance] setTTSEngienManagerDelegate:self];
    NSLog(@"%@, 设置TTS委托接口调用了", TAG);
}

//设置播报合成音
-(void)test_setSpeaker{
    [[[DDSManager shareInstance] getTTSInstance] setSpeaker:@"zhilingf"];
    NSLog(@"%@, 设置TTS合成音接口调用了", TAG);
}

//设置播报语速
-(void)test_setSpeed{
    [[[DDSManager shareInstance] getTTSInstance] setSpeed:1.0];
    NSLog(@"%@, 设置TTS语速接口调用了", TAG);
}

//设置播报音量
-(void)test_setVolume{
    [[[DDSManager shareInstance] getTTSInstance] setVolume:50];
    NSLog(@"%@, 设置TTS音量接口调用了", TAG);
}

//获取播报合成音
-(void)test_getSpeaker{
    NSString * speaker = [[[DDSManager shareInstance] getTTSInstance] getSpeaker];
    NSLog(@"%@, TTS合成音是:%@", TAG, speaker);
}

//获取播报语速
-(void)test_getSpeed{
    float speed = [[[DDSManager shareInstance] getTTSInstance] getSpeed];
    NSLog(@"%@, TTS语速是:%f", TAG, speed);
}

//获取播报音量
-(void)test_getVolume{
    int tts_volume = [[[DDSManager shareInstance] getTTSInstance] getVolume];
    NSLog(@"%@, 音量大小:%d", TAG, tts_volume);
}

//暂停播报
-(void)test_pausePlayer{
    [[[DDSManager shareInstance] getTTSInstance] pausePlayer];
    NSLog(@"%@, 暂停播报接口调用了", TAG);
}

//恢复播报
-(void)test_resetPlayer{
    [[[DDSManager shareInstance] getTTSInstance] resetPlayer];
    NSLog(@"%@, 恢复播报接口调用了", TAG);
}

//设置TTS 云端合成
-(void)test_setTTSCloud{
    [[[DDSManager shareInstance] getTTSInstance] setmode:1];
}

//设置TTS 本地合成
-(void)test_setTTSLocal{
    [[[DDSManager shareInstance] getTTSInstance] setmode:0];
}


//设置云端对话管理
-(void)test_setDialogCloud{
    [[DDSManager shareInstance] setDialogMode:2];
}

//设置本地对话管理
-(void)test_setDialogLocal{
    [[DDSManager shareInstance] setDialogMode:1];
}


#pragma mark- test webview支持的delegate消息响应

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
//    if(request == nil){
//        dispatch_async(dispatch_get_main_queue(), ^{
//             [self initH5];
//        });
//    }
    NSLog(@"%@, webview shouldStartLoadWithRequest request:%@, navigationType:%ld", TAG, request, (long)navigationType);
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"%@, webview webViewDidStartLoad", TAG);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"%@, webview webViewDidFinishLoad", TAG);
    [self sendHiMessage];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"%@, webview didFailLoadWithError %@", TAG, error);
}

#pragma mark - test Oauth支持的delegate消息响应
- (void)onAccessTokenSuccess:(NSString *)token{
    if(token){
        NSLog(@"%@, token is %@", TAG, token);
        int type = 1;
        [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"ACCESS_TOKEN"];
        [[NSUserDefaults standardUserDefaults] setInteger:type forKey:@"LOGIN_STATE"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else{
        NSLog(@"%@, token is nil", TAG);
        [self afterInit];
        return;
    }
    
    if(updateFlag){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [paramUpdate setObject:token forKey:K_ACCESS_TOKEN];
            [[DDSManager shareInstance] startWithdelegate:self DDSConfig:paramUpdate withConfigServerType:aiosConfigItem];
        });
    }else{
        [self afterInit];
    }
}

#pragma mark - test external recorder支持的delegate消息响应
-(void) processingData: (NSData*) data segmentNum: (int) segmentNum sessionId: (NSString *) sessionId{
    [self test_feedPcm:data];
}

#pragma mark- test observer支持的delegate消息响应
//MessageObserver的消息响应
-(void)onMessage:(NSString *)message  data:(NSString*)data {
    
    //vad触发时的通知
    if([message isEqualToString:@"sys.vad.begin"]){
        NSLog(@"%@, sys.vad.begin响应了，数据: %@", TAG, data);
    }
    //vad结束时的通知
    if([message isEqualToString:@"sys.vad.end"]){
        NSLog(@"%@, sys.vad.end响应了，数据: %@", TAG, data);
    }
    //数据上传结果的通知
    if([message isEqualToString:@"sys.upload.result"]){
        NSLog(@"%@, sys.upload.result响应了，数据: %@", TAG, data);
    }
    //唤醒结果的通知，与配置项K_WAKEUP_ROUTER配合使用，只获取唤醒结果
    if ([message isEqualToString:@"sys.wakeup.result"]) {
        NSLog(@"%@, sys.wakeup.result响应了，数据:%@", TAG, data);
    }
    //识别结果的通知，与配置项K_ASR_ROUTER配合使用,只获取识别结果
    if ([message isEqualToString:@"context.input.text"]) {
        NSLog(@"%@, context.input.text响应了，数据:%@", TAG, data);
    }
    //对话过程中的错误通知
    if([message isEqualToString:@"sys.dialog.error"]){
        NSLog(@"%@, sys.dialog.error响应了，数据: %@", TAG, data);
    }
    //speak播报结束时的通知
    if([message isEqualToString:@"speak.end"]){
        NSDictionary *dic = [self dictionaryWithJsonString:data];
        if([[dic objectForKey:@"ttsId"] isEqualToString:@"1001"]){
            NSLog(@"%@, speak.end ttsid is 1001 响应了，数据:%@", TAG, data);
        }
    }
    //对话开始的通知
    if ([message isEqualToString:@"sys.dialog.start"]) {
        NSLog(@"%@, sys.dialog.start响应了，数据: %@", TAG, data);
    }
    //对话结束的通知
    if ([message isEqualToString:@"sys.dialog.end"]) {
        NSLog(@"%@, sys.dialog.end响应了，数据: %@", TAG, data);
    }
    //对话静止状态
    if ([message isEqualToString:@"avatar.silence"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showState:1];
        });
    }
    //对话倾听状态
    if ([message isEqualToString:@"avatar.listening"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showState:2];
            NSLog(@"%@, volume is %@", TAG, data);
            volume = [[[self dictionaryWithJsonString:data] objectForKey:@"volume"] floatValue];
            
        });
    }
    //对话识别状态
    if ([message isEqualToString:@"avatar.understanding"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showState:3];
        });
        
    }
    //对话播报状态
    if ([message isEqualToString:@"avatar.speaking"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showState:4];
        });
    }
    //对话暂停状态
    if ([message isEqualToString:@"avatar.standby"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showState:1];
        });
    }
}

//收集录音机音频数据
-(void)onMessageRecorder:(NSString *)message  data:(NSData *)data{
    if ([message isEqualToString:K_RECORDER_PCM]) {
        int len = (int)[data length];
        //NSLog(@"%@, 音频数据长度：%d", TAG, len);
    }
}

//CommandObserver的消息响应
-(void)onCall:(NSString *)command data:(NSString *)data {
    //收到command消息，调出第三方地图，开始导航，即须集成的SDK
    if([command isEqualToString:@"navi.route"]) {
        NSLog(@"%@, navi.route data:%@", TAG, data);
        NSMutableDictionary  *dic = [self dictionaryWithJsonString:data];
//        [self test_disableWakeup];
//        [self test_stopDialog];
        dispatch_async(dispatch_get_main_queue(), ^{
            //调用第三方导航
            NSLog(@"此处调用第三方导航api接口");
        });
    }
    //退出地图
    if([command isEqualToString:@"navi.close"]){
        //调用第三方导航
        NSLog(@"此处调用第三方导航api接口");
    }
    //收到command消息，调出打电话功能
    if ([command isEqualToString:@"sys.action.call"]) {
        NSLog(@"%@, sys.action.call data:%@", TAG, data);
        NSMutableDictionary  *dic = [self dictionaryWithJsonString:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            if([[dic allKeys] containsObject:@"phone"]){
                [contact callPhone:[dic objectForKey:@"phone"] object:self];
            }
        });
    }
    
    //测试本地技能，从DUI获取到自己上传的经纬度，调用导航的SDK完成导航功能，
    if ([command isEqualToString:@"test.request"]) {
        NSLog(@"%@, local skill created by me, data:%@", TAG, data);
    }
    //响应命令唤醒词open.window
    if([command isEqualToString:@"open.window"]) {
        NSLog(@"%@, commandWakeup open.window data:%@", TAG, data);
    }
    //响应命令唤醒词open.door
    if([command isEqualToString:@"open.door"]) {
        NSLog(@"%@, addCommandWakeup open.door data:%@", TAG, data);
    }
}

//NativeApiObserver的消息响应
-(void)onQuery:(NSString *)nativeApi data:(NSString *)data {
    //拨打联系人
    if ([nativeApi isEqualToString:@"sys.query.contacts"]) {
        NSLog(@"%@, sys.query.contacts data:%@", TAG, data);
        NSMutableDictionary  *dic = [self dictionaryWithJsonString:data];
        ListWidget * listWidget = [[ListWidget alloc] init];
        ContentWidget * contentWidget = [[ContentWidget alloc] init];
        if ([[dic allKeys] containsObject:@"联系人"]) {
            [contentWidget setTitle:[dic objectForKey:@"联系人"]];
            if ([[contact.myDict allKeys] containsObject:[dic objectForKey:@"联系人"]]) {
                [contentWidget setSubTitle:[contact.myDict objectForKey:[dic objectForKey:@"联系人"]]];
                [contentWidget addExtra:@"phone" Value:[contact.myDict objectForKey:[dic objectForKey:@"联系人"]]];
            } else {
                NSLog(@"%@, 本地没有这个联系人",TAG);
            }
        } else {
            NSLog(@"%@, 服务端没有返回联系人",TAG);
        }
        [listWidget addContentWidget:contentWidget];
        [[DDSManager shareInstance] feedbackNativeApiResult:nativeApi duiWidget:listWidget];
        NSLog(@"%@, 收到联系人的消息，调用feedbackNativeApiResult反馈给服务端", TAG);
    }
    
    //测试本地技能,上传目的地的经纬度给DUI，test.navigation这个是技能中自己定制的nativeApi
    if ([nativeApi isEqualToString:@"test.navigation"]) {
        ListWidget * listWidget = [[ListWidget alloc] init];
        ContentWidget * contentWidget = [[ContentWidget alloc] init];
        [contentWidget addExtra:@"let" Value:@"维度"];
        [contentWidget addExtra:@"nlg" Value:@"经度"];
        [listWidget addContentWidget:contentWidget];
        [[DDSManager shareInstance] feedbackNativeApiResult:nativeApi duiWidget:listWidget];
    }
    
    //设置闹钟
    if([nativeApi isEqualToString:@"alarm.set"]){
        NSLog(@"%@, alarm.set data:%@", TAG, data);
        NSMutableDictionary  *dic = [self dictionaryWithJsonString:data];
        TextWidget * textWidget = [[TextWidget alloc] init];
        NSString * date_time = @"闹钟提醒:";
        //NSString * string = @"yyyy-mm-dd hh:mm:ss";
        NSDate *currentDate = [NSDate date];
        NSMutableString *dateString = [[NSMutableString alloc] initWithString:[alarmUtil stringFromDate:currentDate]];
        
        //设置本地闹钟
        UILocalNotification *notification = [[UILocalNotification alloc]  init];
        notification.timeZone = [NSTimeZone localTimeZone];
        notification.repeatInterval = 0;//NSWeekCalendarUnit;
        notification.soundName = UILocalNotificationDefaultSoundName;
        notification.alertAction = @"知道了！";
        //notification.applicationIconBadgeNumber += 1;
        notification.applicationIconBadgeNumber = [[[UIApplication sharedApplication] scheduledLocalNotifications] count]+1;
        notification.hasAction = YES;
        notification.alertTitle = @"提醒";
        
        if([[dic allKeys] containsObject:@"date"] || [[dic allKeys] containsObject:@"time"] || [[dic allKeys] containsObject:@"festival"]){
            if([[dic allKeys] containsObject:@"date"]){
                NSMutableString * string =[[NSMutableString alloc] initWithString: [dic objectForKey:@"date"]];
                [string insertString:@"-" atIndex:4];
                [string insertString:@"-" atIndex:7];
                NSRange range = {0, 10};
                dateString = [dateString stringByReplacingCharactersInRange:range withString:string];
                date_time = [date_time stringByAppendingString:string];
            }
            if([[dic allKeys] containsObject:@"time"]){
                date_time = [date_time stringByAppendingFormat:@" %@",[dic objectForKey:@"time"]];
                NSRange range = {11, 8};
                dateString = [dateString stringByReplacingCharactersInRange:range withString:[dic objectForKey:@"time"]];
            }
            if([[dic allKeys] containsObject:@"festival"]){
                date_time = [date_time stringByAppendingString:[dic objectForKey:@"festival"]];
                NSRange range = {0, 10};
                if([alarmUtil festivalToDateString:[dic objectForKey:@"festival"]]){
                    NSString * festivalDate = [alarmUtil festivalToDateString:[dic objectForKey:@"festival"]];
                    NSArray *festivalArray = [festivalDate componentsSeparatedByString:@"-"];
                    NSArray *dateStringArray = [dateString componentsSeparatedByString:@"-"];
                    dateString = [dateString stringByReplacingCharactersInRange:range withString:[alarmUtil lunToSun:dateStringArray[0] month:festivalArray[0] day:festivalArray[1]]];
                }else{
                    NSLog(@"%@, 节日转换日期不成功,请添加对应的日期转换格式", TAG);
                }
            }
        }else{
            date_time = [date_time stringByAppendingString:@"not set alarmTime"];
        }
        if([[dic allKeys] containsObject:@"event"]){
            date_time = [date_time stringByAppendingString:[dic objectForKey:@"event"]];
            notification.alertBody = [dic objectForKey:@"event"];
        }
        notification.fireDate = [alarmUtil dateFromString:dateString]; // 周一早上八点
        //notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:10];
        NSDictionary * infoDict = [NSDictionary dictionaryWithObjectsAndKeys:dateString,@"dateTime", nil];
        notification.userInfo = infoDict;
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        
        [textWidget setText:date_time];
        [_alarmArray addObject:date_time];
        [[DDSManager shareInstance] feedbackNativeApiResult:nativeApi duiWidget:textWidget];
        NSLog(@"%@, 收到设置闹钟提醒，调用feedbackNativeApiResult反馈给服务端", TAG);
    }
    //查询闹钟
    if([nativeApi isEqualToString:@"alarm.list"]){
        NSLog(@"%@, alarm.list data:%@", TAG, data);
        NSMutableDictionary  *dic = [self dictionaryWithJsonString:data];
        ListWidget * listWidget = [[ListWidget alloc] init];
        for (int k=0; k<[_alarmArray count]; k++) {
            ContentWidget * contentWidget = [[ContentWidget alloc] init];
            [contentWidget setTitle:[[dic objectForKey:@"object"] stringByAppendingFormat:@"%d:", k+1]];
            [contentWidget setSubTitle:_alarmArray[k]];
            [listWidget addWidget:contentWidget];
        }
        [[DDSManager shareInstance] feedbackNativeApiResult:nativeApi duiWidget:listWidget];
        NSLog(@"%@, 收到查询闹钟提醒，调用feedbackNativeApiResult反馈给服务端", TAG);
    }
    //删除所有闹钟
    if([nativeApi isEqualToString:@"alarm.delete"]){
        NSLog(@"%@, alarm.list data:%@", TAG, data);
        [_alarmArray removeAllObjects];
        TextWidget * textWidget = [[TextWidget alloc] init];
        [textWidget setText:@"已为你删除所有闹钟"];
        [[DDSManager shareInstance] feedbackNativeApiResult:nativeApi duiWidget:textWidget];
        NSLog(@"%@, 收到查询闹钟提醒，调用feedbackNativeApiResult反馈给服务端", TAG);
        //取消所有的本地通知
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
}

#pragma mark- test DDS支持的delegate消息响应
-(void)onInitComplete:(BOOL)isFull {
    if(isFull){
        NSLog(@"%@, DDS start onInitComplete is success", TAG);
        isVad = [self getVad];
        isA = isVad;
//        NSString *accessToken = [DDSOAuthDataTool shareInstance].access_token;
//        [[DDSManager shareInstance] rpcURL:@"/local_auth/update_access_token" list:[@[accessToken] mutableCopy]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self initSubscribe];
            [self initH5];
            [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {}];
            if(isA){
                stateFlag = 0;
                _btnMic.adjustsImageWhenHighlighted = NO;
                _btnMic.layer.shadowOffset =  CGSizeMake(0, 0);
                _btnMic.layer.shadowOpacity = 0;
                _btnMic.layer.shadowColor =  [UIColor whiteColor].CGColor;
                [_btnMic.layer setMasksToBounds:NO];
                [_btnMic.layer setBorderWidth:0];
                [_btnMic setTitle:@"" forState:UIControlStateNormal];
                _btmicWidth.constant = 100;
                _btmicHeigth.constant = 90;
                [self showState:1];
            }else{
                if(view){
                    [view removeFromSuperview];
                    view = nil;
                }
                stateFlag = 0;
                _btmicWidth.constant = 200;
                _btmicHeigth.constant = 40;
                _btnMic.layer.cornerRadius=5;
                _btnMic.adjustsImageWhenHighlighted = YES;
                _btnMic.backgroundColor = [UIColor whiteColor];
                [_btnMic.layer setMasksToBounds:YES];
                [_btnMic.layer setBorderWidth:1.0];
                [_btnMic.layer setBorderColor:[UIColor grayColor].CGColor];
                _btnMic.titleLabel.font= [UIFont systemFontOfSize: 20];
                _btnMic.titleLabel.text = @"按住 说话";
                [_btnMic setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                [_btnMic setTitle:@"按住 说话" forState:UIControlStateNormal];
            }
        });
    }
    else{
        NSLog(@"%@, onInitComplete is faied", TAG);
    }
    if(updateFlag1){
        [[DDSManager shareInstance] update];
        updateFlag1 = NO;
    }
}

-(void)onAuthSuccess{
    NSLog(@"%@, onAuthSuccess is successed", TAG);
    [[[DDSManager shareInstance] getDDSWakeupEngineManager] enableWakeup];

    [[[DDSManager shareInstance] getTTSInstance] speak:@"启动完成了，欢迎使用" priority:1 ttsId:@"1001"];
//    上传手机联系人，用于打电话
//    [self test_updateVocabs_contacts];
//    监听打电话功能，用于逻辑控制
//    [contact detectCall];
}

-(void)onAuthFailed:(NSString*)what Error:(NSString*)error{
    NSLog(@"%@, onAuthFailed is failed,code:%@,error:%@",TAG, what, error);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self presentViewController:alertController animated:YES completion:nil];
    });
}

-(void)onError:(int)what Error:(NSString*)error{ //int what, String error
    NSLog(@"%@,update onError code:%d, error:%@", TAG, what, error);
    if(what == 70303){
        [[[DDSManager shareInstance] getTTSInstance] speak:@"没有发现新版本，不需要更新" priority:1 ttsId:@"1002"];
    }
}

-(void)onUpdateFound:(NSString *)detail{
    NSLog(@"%@, update onUpdateFound:%@", TAG, detail);
}

-(void)onUpdateFinish{
    if(updateFlag){
        updateFlag = NO;
        [[NSUserDefaults standardUserDefaults] setObject: [paramUpdate objectForKey:K_PRODUCT_ID] forKey:@"ProductId"];
        [[NSUserDefaults standardUserDefaults] setObject: [paramUpdate objectForKey:K_ALIAS_KEY] forKey:@"AliasKey"];
        [[NSUserDefaults standardUserDefaults] setObject:paramUpdate forKey:@"newProduct"];
        [[NSUserDefaults standardUserDefaults] setInteger:aiosConfigItem forKey:@"serverType"];
        [[NSUserDefaults standardUserDefaults] setObject:@"api_key" forKey:@"AUTH_TYPE"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5* NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [SVProgressHUD dismiss];
    });
    NSLog(@"%@, update onUpdateFinish", TAG);
}

-(void)onDownloadProgress:(float) progress{
    NSLog(@"%@, update onDownloadProgress:%f", TAG, progress);
    if(progress >= 100){
        [SVProgressHUD showWithStatus:[[@"Download:" stringByAppendingString: [[NSString stringWithFormat:@"%f",progress] substringWithRange:NSMakeRange(0,3)]] stringByAppendingString:@"%"]];
    }
    if(progress<100 && progress>=10){
        [SVProgressHUD showWithStatus:[[@"Download:" stringByAppendingString: [[NSString stringWithFormat:@"%f",progress] substringWithRange:NSMakeRange(0,2)]] stringByAppendingString:@"%"]];
    }
    if(progress<10 && progress>=0){
        [SVProgressHUD showWithStatus:[[@"Download:" stringByAppendingString: [[NSString stringWithFormat:@"%f",progress] substringWithRange:NSMakeRange(0,1)]] stringByAppendingString:@"%"]];
    }
}

-(void)onUpgrade:(NSString *) version{
    NSLog(@"%@, update onUpgrade %@", TAG, version);
}

//外部TTS接口，开始合成回调，必须将配置项K_TTS_MODE设为external
-(void)onStart:(NSString *)type data:(NSString *)content{
    dispatch_async(dispatch_get_main_queue(), ^{
        tts =[[ThirdPartTTS alloc] init];
        [tts startTTS:content];
    });
    NSLog(@"%@, 开始外部TTS合成接口调用了, %@", TAG, content);
}

//外部TTS接口，打断播报终止合成回调，必须将配置项K_TTS_MODE设为external
-(void)onStop{
    dispatch_async(dispatch_get_main_queue(), ^{
        [tts stopTTS];
    });
    NSLog(@"%@, 停止外部TTS合成接口调用了", TAG);
}

#pragma mark- test ASR支持的delegate消息响应
//识别回调，检测到用户说话
-(void) ASRBeginningOfSpeech{
    NSLog(@"%@, ASREngine 检测到用户开始说话", TAG);
}

//识别回调，检测到用户结束说话
-(void) ASREndOfSpeech{
    NSLog(@"%@, ASREngine 检测到用户结束说话", TAG);
}

//识别回调，送去识别的音频数据
-(void) ASRBufferReceived:(NSData *) buffer{
    NSLog(@"%@, ASREngine 用户说话的音频数据: %@", TAG, buffer);
}

//识别回调，实时反馈结果
-(void) ASRPartialResults:(NSString *) results{
    NSLog(@"%@, ASREngine 实时识别结果反馈: %@", TAG, results);
}

//识别回调，最终识别结果
-(void) ASRFinalResults:(NSString *) results{
    NSLog(@"%@, ASREngine 最终识别结果反馈: %@", TAG, results);
}

//识别回调，识别过程中产生的错误
-(void)ASRError:(NSString*) error{
    NSLog(@"%@, ASREngine 识别过程中发生的错误: %@", TAG, error);
}


//识别回调，音量大小
-(void) ASRRmsChanged:(float)rmsdB{
    NSLog(@"%@, ASREngine 用户说话的音量分贝: %f", TAG, rmsdB);
}

#pragma mark- test TTS支持的delegate消息响应
//实现TTS回调,开始播报
-(void) TTSBeginning:(NSString*)ttsId{
    NSLog(@"%@, TTSEngine 开始播报: %@", TAG, ttsId);
}

//实现TTS回调,合成的音频数据
-(void) TTSReceived:(NSData*)data{
    NSLog(@"%@, TTSEngine 收到音频，此方法会回调多次，直至data为0，音频结束: %@", TAG, data);
}

//实现TTS回调,播报结束
-(void) TTSEnd:(NSString*)ttsId status:(int)status{
    NSLog(@"%@, TTSEngine TTS播报结束, ttsid: %@ status: %d", TAG, ttsId, status);
}

//实现TTS回调,合成过程中的错误
-(void) TTSError:(NSString*) error{
    NSLog(@"%@, TTSEngine 出现错误: %@", TAG, error);
}

- (IBAction)btnAction:(id)sender{
    [self test_stopDialog];
}

@end
