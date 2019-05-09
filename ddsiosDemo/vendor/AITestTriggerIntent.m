//
//  AITestTriggerIntent.m
//  ddsiosDemo
//
//  Created by aispeech009 on 22/10/2017.
//  Copyright © 2017 speech. All rights reserved.
//

#import "AITestTriggerIntent.h"
#import "LYYTextField.h"
#import "DDSManager.h"
#import "AITestDUICtrl.h"

@interface AITestTriggerIntent ()

@property (weak, nonatomic) IBOutlet LYYTextField *text1;
@property (weak, nonatomic) IBOutlet LYYTextField *text2;
@property (weak, nonatomic) IBOutlet LYYTextField *text3;
@property (weak, nonatomic) IBOutlet LYYTextField *text4;
@property (weak, nonatomic) IBOutlet LYYTextField *text5;
@property (weak, nonatomic) IBOutlet UIButton *btnTriggerIntentOk;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *view4;
@property (weak, nonatomic) IBOutlet UIView *view5;
@property (weak, nonatomic) IBOutlet UIView *view6;

@property (weak, nonatomic) IBOutlet UIButton *btnTriggerIntentReset;

@end

@implementation AITestTriggerIntent

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _view1.frame = CGRectMake(11, 0, self.view.frame.size.width-41, 1);
    
    _view2.frame = CGRectMake(11, 50, self.view.frame.size.width-41, 1);
    _view3.frame = CGRectMake(11, 98, self.view.frame.size.width-41, 1);
    _view4.frame = CGRectMake(11, 146, self.view.frame.size.width-41, 1);
    _view5.frame = CGRectMake(11, 190, self.view.frame.size.width-41, 1);
    _view6.frame = CGRectMake(11, 240, self.view.frame.size.width-41, 1);
    
    _btnTriggerIntentOk.frame = CGRectMake(21, 370, self.view.frame.size.width-41, 50);
    _btnTriggerIntentOk.layer.cornerRadius=5;
    //_btnTriggerIntentOk.adjustsImageWhenHighlighted = YES;
    _btnTriggerIntentOk.backgroundColor = [UIColor whiteColor];
    [_btnTriggerIntentOk.layer setMasksToBounds:YES];
    [_btnTriggerIntentOk.layer setBorderWidth:1.0];
    [_btnTriggerIntentOk.layer setBorderColor:[UIColor grayColor].CGColor];
    _btnTriggerIntentOk.titleLabel.font= [UIFont systemFontOfSize: 20];
    [_btnTriggerIntentOk setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_btnTriggerIntentOk setTitle:@"点击 触发" forState:UIControlStateNormal];
    
    //_btnTriggerIntentOk.backgroundColor = [UIColor clearColor];
    
    _btnTriggerIntentReset.layer.cornerRadius=5;
    //_btnTriggerIntentReset.adjustsImageWhenHighlighted = YES;
    _btnTriggerIntentReset.backgroundColor = [UIColor whiteColor];
    [_btnTriggerIntentReset.layer setMasksToBounds:YES];
    [_btnTriggerIntentReset.layer setBorderWidth:1.0];
    [_btnTriggerIntentReset.layer setBorderColor:[UIColor grayColor].CGColor];
    _btnTriggerIntentReset.titleLabel.font= [UIFont systemFontOfSize: 20];
    [_btnTriggerIntentReset setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_btnTriggerIntentReset setTitle:@"重置" forState:UIControlStateNormal];
    
    self.text1.placeholder = @"请输入技能名称,必填";
    self.text1.placeholderColor = [UIColor blackColor];
    self.text1.clearButtonMode=UITextFieldViewModeWhileEditing;
    
    self.text2.placeholder = @"请输入任务名称,必填";
    self.text2.placeholderColor = [UIColor blackColor];
    self.text2.clearButtonMode=UITextFieldViewModeWhileEditing;
    
    self.text3.placeholder = @"请输入意图名称,必填";
    self.text3.placeholderColor = [UIColor blackColor];
    self.text3.clearButtonMode=UITextFieldViewModeWhileEditing;
    
    self.text4.placeholder = @"请输入语义槽(须成对出现)名称";
    self.text4.placeholderColor = [UIColor blackColor];
    self.text4.clearButtonMode=UITextFieldViewModeWhileEditing;
    
    self.text5.placeholder = @"请输入语义槽(须成对出现)取值";
    self.text5.placeholderColor = [UIColor blackColor];
    self.text5.clearButtonMode=UITextFieldViewModeWhileEditing;
    
    [_btnTriggerIntentOk addTarget:self action:@selector(triggerIntentOkRelease) forControlEvents:UIControlEventTouchUpInside];
    [_btnTriggerIntentOk addTarget:self action:@selector(triggerIntentOkPress) forControlEvents:UIControlEventTouchDown];
    
    
    [_btnTriggerIntentReset addTarget:self action:@selector(triggerIntentResetRelease) forControlEvents:UIControlEventTouchUpInside];
    [_btnTriggerIntentReset addTarget:self action:@selector(triggerIntentResetPress) forControlEvents:UIControlEventTouchDown];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)even {
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 按钮事件

-(void)triggerIntentOkRelease{
    DDSManager *manager = [DDSManager shareInstance];
    
    if (self.text4.text != nil && self.text5.text != nil) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:(NSString*)self.text5.text forKey:(NSString*)self.text4.text];
        [manager triggerIntent:(NSString*)self.text1.text task:(NSString*)self.text2.text intent:(NSString*)self.text3.text slots:dic];
        
    }else{
        [manager triggerIntent:(NSString*)self.text1.text task:(NSString*)self.text2.text intent:(NSString*)self.text3.text slots:nil];
    }
    _btnTriggerIntentOk.backgroundColor = [UIColor whiteColor];
    [_btnTriggerIntentOk setTitle:@"点击 触发" forState:UIControlStateNormal];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)triggerIntentOkPress{
    
    _btnTriggerIntentOk.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    [_btnTriggerIntentOk setTitle:@"松开 结束" forState:UIControlStateNormal];
}

-(void)triggerIntentResetRelease{
    _btnTriggerIntentReset.backgroundColor = [UIColor whiteColor];
    
    //self.text1.clearButtonMode=UITextFieldViewModeWhileEditing;
}

-(void)triggerIntentResetPress{

    _btnTriggerIntentReset.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    //[_btnTriggerIntentReset setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    //[_btnTriggerIntentOk setTitle:@"重置" forState:UIControlStateNormal];

    //[_btnMic setTitle:@"按住 说话" forState:UIControlStateNormal];
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
